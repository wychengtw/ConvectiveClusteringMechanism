load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/time_axis_labels.ncl"

begin

cmap = (/ (/255.,255.,255./),(/  0.,  0.,  0./),\
          (/255.,255.,255./),(/126.,229., 91./),(/ 46.,178., 57./),\
          (/255.,255.,100./),(/255.,170., 80./),(/255., 70.,  0./),\
          (/150., 34., 34./),(/237.,  0.,237./),(/137.,103.,205./) /)/255.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

type = "x11"

nstart        = 5
nexp          = 1

;casenamelist  = (/"1014","1016","1018","1020","1022"/)
casename  = 1014

startnamelist = (/"2011101318","2011101321","2011101400","2011101403","2011101406"/)
;startnamelist = (/"2011"+tostring(casename-1)+"18",\
;                  "2011"+tostring(casename-1)+"21",\
;                  "2011"+tostring(casename)+"00",\
;                  "2011"+tostring(casename)+"03",\
;                  "2011"+tostring(casename)+"06"/)
;lstartnamelist = (/"2011101318"/)

expnamelist = (/"mp08_6th"/)
;                "mp08_6th_homoQv_tau600s"/)
;                "mp08_6th_homoQv_tau600s",\
;                "mp08_6th_homoRth_tau600s",\
;                "mp08_6th_homoT_tau600s",\
;                "mp08_6th_homoUVbl_tau600s",\
;                "mp08_6th_homoUVlt_tau600s",\
;                "mp08_6th_homoUVut_tau600s"/)


varnamea       = "RR"
varnameb       = "B2Iorg"
varnamec       = "B2N"
varnamed       = "B2N"

filename      = casename+"_"+varnamea+"_"+varnameb+"_"+varnamec+"_"+varnamed+"_"+expnamelist(0)

nfs = 49

;tgthr = (/56,66,68,49,51,51,55,50,69,68/) ; from obs
;tgthr = (/58,66,68,49,55,60,60,50,69,72/)
tgthr = 58

mfs = dimsizes(tgthr)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

rr_tmp        = new((/mfs,nfs/),float)
b2n_tmp       = new((/mfs,nfs/),float)
b2s_tmp       = new((/mfs,nfs/),float)
b2d0_tmp      = new((/mfs,nfs/),float)
b2iorg_tmp    = new((/mfs,nfs/),float)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

time        = new((/nfs/),double)

RR          = new((/nstart,nexp,nfs/),float)
B2N         = new((/nstart,nexp,nfs/),float)
B2S         = new((/nstart,nexp,nfs/),float)
B2D0        = new((/nstart,nexp,nfs/),float)
B2Iorg      = new((/nstart,nexp,nfs/),float)

RR_mnmx     = new((/3,nexp,nfs/),float)
B2N_mnmx    = new((/3,nexp,nfs/),float)
B2S_mnmx    = new((/3,nexp,nfs/),float)
B2D0_mnmx   = new((/3,nexp,nfs/),float)
B2Iorg_mnmx = new((/3,nexp,nfs/),float)

do istart = 0 , nstart-1
do iexp   = 0 , nexp-1

 starttime = startnamelist(istart)
 expname   = expnamelist(iexp)

 datafile  = addfile("data/analysis/"+casename+"/start"+starttime+"/"+expname+".nc","r")

 rr        = datafile->RR
 b2n       = datafile->B2N
 b2s       = datafile->B2S
 b2d0      = datafile->B2D0
 b2iorg    = datafile->B2Iorg

; rr(0,505)   = rr@_FillValue ; 15 Oct. 18 UTC
; b2n1(0,0:504)  = b2n0(0,0:504)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 do jfs = 0 , mfs-1
  do ifs = 0 , nfs-1
   tgtind = tgthr(jfs) * 12
   hrp = ((nfs-1)/2)*12 ; time resolution = 5 minutes
   rr_tmp(jfs,ifs)         = avg(rr(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2n_tmp(jfs,ifs)        = avg(b2n(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2s_tmp(jfs,ifs)        = avg(b2s(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2d0_tmp(jfs,ifs)       = avg(b2d0(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2iorg_tmp(jfs,ifs)     = avg(b2iorg(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
  end do
 end do

 rr_o        = dim_avg_n(rr_tmp,0)
 b2n_o       = dim_avg_n(b2n_tmp,0)
 b2s_o       = dim_avg_n(b2s_tmp,0)
 b2d0_o      = dim_avg_n(b2d0_tmp,0)
 b2iorg_o    = dim_avg_n(b2iorg_tmp,0)

 RR(istart,iexp,:)      = rr_o
 B2N(istart,iexp,:)     = b2n_o
 B2S(istart,iexp,:)     = b2s_o
 B2D0(istart,iexp,:)    = b2d0_o
 B2Iorg(istart,iexp,:)  = b2iorg_o

end do ; iexp
end do ; istart

;RR(1:nexp-1,11) = RR(0,11)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RR        = runave_n(RR,3,0,2)
B2N       = runave_n(B2N,3,0,2)
B2S       = runave_n(B2S,3,0,2)
B2D0      = runave_n(B2D0,3,0,2)
B2Iorg    = runave_n(B2Iorg,3,0,2)

RR_mnmx(0,:,:) = dim_avg_n(RR,0)
RR_mnmx(1,:,:) = RR_mnmx(0,:,:) - sqrt(dim_variance_n(RR,0))
RR_mnmx(2,:,:) = RR_mnmx(0,:,:) + sqrt(dim_variance_n(RR,0))

B2N_mnmx(0,:,:) = dim_avg_n(B2N,0)
B2N_mnmx(1,:,:) = B2N_mnmx(0,:,:) - sqrt(dim_variance_n(B2N,0))
B2N_mnmx(2,:,:) = B2N_mnmx(0,:,:) + sqrt(dim_variance_n(B2N,0))

B2S_mnmx(0,:,:) = dim_avg_n(B2S,0)
B2S_mnmx(1,:,:) = B2S_mnmx(0,:,:) - sqrt(dim_variance_n(B2S,0))
B2S_mnmx(2,:,:) = B2S_mnmx(0,:,:) + sqrt(dim_variance_n(B2S,0))

B2D0_mnmx(0,:,:) = dim_avg_n(B2D0,0)
B2D0_mnmx(1,:,:) = B2D0_mnmx(0,:,:) - sqrt(dim_variance_n(B2D0,0))
B2D0_mnmx(2,:,:) = B2D0_mnmx(0,:,:) + sqrt(dim_variance_n(B2D0,0))

B2Iorg_mnmx(0,:,:) = dim_avg_n(B2Iorg,0)
B2Iorg_mnmx(1,:,:) = B2Iorg_mnmx(0,:,:) - sqrt(dim_variance_n(B2Iorg,0))
B2Iorg_mnmx(2,:,:) = B2Iorg_mnmx(0,:,:) + sqrt(dim_variance_n(B2Iorg,0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

var            = True
var@RR         = RR_mnmx
var@B2N        = B2N_mnmx
var@B2S        = B2S_mnmx
var@B2D0       = B2D0_mnmx
var@B2Iorg     = B2Iorg_mnmx

varlongname            = True
varlongname@RR         = "Rain rate (mm/hr)"
varlongname@B2N        = "N"
varlongname@B2S        = "CCE size (km~S~2~N~)"
varlongname@B2D0       = "D0"
varlongname@B2Iorg     = "Iorg"

vara = var@$varnamea$
varb = var@$varnameb$
varc = var@$varnamec$
vard = var@$varnamed$

vara@long_name = varlongname@$varnamea$
varb@long_name = varlongname@$varnameb$
varc@long_name = varlongname@$varnamec$
vard@long_name = varlongname@$varnamed$

;;;;;;;;;;;;;;;;;;;;

resxy                       = True
resxy@gsnXYBarChart         = False
resxy@gsnDraw               = False
resxy@gsnFrame              = False

resxyy1=resxy
resxyy2=resxy
resxyy3=resxy
resxyy4=resxy

resxyy1@vpXF                        = 0.21
resxyy1@vpWidthF                    = 0.58 ; Set width and height of plot.
resxyy1@vpHeightF                   = 0.2
resxyy1@xyLineColor                 = "black"
resxyy1@xyLineThicknesses           = 4. ; thicker line
resxyy1@trXMinF                     = -24.
resxyy1@trXMaxF                     =  24.
resxyy1@trYMinF                     = 0.
resxyy1@trYMaxF                     = 2.5
resxyy1@tmYLMinorOn                 = False
resxyy1@tmYLLabelFontHeightF        = 0.015
resxyy1@tmYLLabelFontColor          = resxyy1@xyLineColor
resxyy1@tiXAxisString               = "time"
resxyy1@tiYAxisString               = varlongname@$varnamea$
resxyy1@tiYAxisFontColor            = resxyy1@xyLineColor
resxyy1@tmYLMode                    = "Explicit"
resxyy1@tmYLValues                  = fspan(0.0,2.5,6)
resxyy1@tmYLLabels                  = sprintf("%3.1f",resxyy1@tmYLValues)

resxyy2@xyLineColor                 = "red";"lightseagreen";"blue";
resxyy2@xyDashPatterns              = 0
resxyy2@xyLineThicknesses           = 4 ; thicker line
resxyy2@trXMinF                     = resxyy1@trXMinF
resxyy2@trXMaxF                     = resxyy1@trXMaxF
resxyy2@trYMinF                     = 0.5
resxyy2@trYMaxF                     = 1.0
resxyy2@tmYRMinorOn                 = False
resxyy2@tiYAxisFontColor            = resxyy2@xyLineColor
resxyy2@tmYRLabelFontColor          = resxyy2@xyLineColor
resxyy2@trYReverse                  = False

resxyy3@xyLineColor                 = "darkgreen";
resxyy3@xyDashPatterns              = 0
resxyy3@xyLineThicknesses           = 4 ; thicker line
resxyy3@trXMinF                     = resxyy1@trXMinF
resxyy3@trXMaxF                     = resxyy1@trXMaxF
resxyy3@trYMinF                     = 0
resxyy3@trYMaxF                     = 120
resxyy2@tmYRMinorOn                 = False
resxyy3@tiYAxisFontColor            = resxyy3@xyLineColor
resxyy3@tmYRLabelFontColor          = resxyy3@xyLineColor
resxyy3@trYReverse                  = False


wks1=gsn_open_wks(type,filename)
gsn_define_colormap(wks1,cmap)

;plot0 = gsn_csm_xy3(wks1,fspan(-24,24,49),vara(0,0,:),varb(0,0,:),varc(0,0,:),resxyy1,resxyy2,resxyy3)

plot01 = gsn_csm_xy (wks1,fspan(-24,24,49),vara(0,0,:),resxyy1)
plot02 = gsn_csm_xy (wks1,fspan(-24,24,49),(2.5/0.5)*(varb(0,0,:)-0.5),resxyy2)
plot03 = gsn_csm_xy (wks1,fspan(-24,24,49),(2.5/120.)*varc(0,0,:),resxyy3)

overlay(plot01,plot02)
overlay(plot01,plot03)

resxyy1@gsnXYFillColors = "gray"
resxyy1@gsnXYFillOpacities = 0.4
resxyy1@xyLineColors     = (/-1,-1/)

resxyy2@gsnXYFillColors = "red"
resxyy2@gsnXYFillOpacities = 0.1
resxyy2@xyLineColors     = (/-1,-1/)

resxyy3@gsnXYFillColors = "darkgreen"
resxyy3@gsnXYFillOpacities = 0.1
resxyy3@xyLineColors     = (/-1,-1/)

;plot1  = gsn_csm_xy3(wks1,fspan(-24,24,49),vara(1:2,0,:),varb(1:2,0,:),0.01*varc(1:2,0,:),resxyy1,resxyy2,resxyy2)

plot11  = gsn_csm_xy (wks1,fspan(-24,24,49),vara(1:2,0,:),resxyy1)
plot12  = gsn_csm_xy (wks1,fspan(-24,24,49),(2.5/0.5)*(varb(1:2,0,:)-0.5),resxyy2)
plot13  = gsn_csm_xy (wks1,fspan(-24,24,49),(2.5/120.)*varc(1:2,0,:),resxyy3)


overlay(plot01,plot11)
overlay(plot01,plot12)
overlay(plot01,plot13)

draw(plot01)
frame(wks1)

end
