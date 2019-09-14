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
nexp          = 8
kfs           = 4

;casenamelist  = (/"1014","1016","1018","1020","1022"/)
casename  = 1014

;startnamelist = (/"2011101318","2011101321","2011101400","2011101403","2011101406"/)
startnamelist = (/"2011"+tostring(casename-1)+"18",\
                  "2011"+tostring(casename-1)+"21",\
                  "2011"+tostring(casename)+"00",\
                  "2011"+tostring(casename)+"03",\
                  "2011"+tostring(casename)+"06"/)

expnamelist = (/"mp08_6th",\
                "mp08_6th_homoQv_tau600s",\
                "mp08_6th_homoNCQv_tau600s",\
                "mp08_6th_homoRth_tau600s",\
                "mp08_6th_homoT_tau600s",\
                "mp08_6th_homoUVbl_tau600s",\
                "mp08_6th_homoUVlt_tau600s",\
                "mp08_6th_homoUVut_tau600s"/)

;fillcolors = (/(/ 65,105,225/),\ ; LFTqv
;               (/ 65,105,225/),\ ; LFTqv
;               (/238,130,238/),\ ; RAD
;               (/255, 99, 71/),\ ; BLT
;               (/255,215,  0/),\ ; BLWS
;               (/127,255,  0/),\ ; LFTWS
;               (/127,255,  0/)\  ; UFTWS
;               /)/255.

fillcolors = (/"lightblue",\ ; LFTqv
               "lightblue",\ ; LFTqv
               "plum",\ ; RAD
               "coral",\ ; BLT
               "gold",\ ; BLWS
               "palegreen",\ ; LFTWS
               "palegreen"\  ; UFTWS
               /)



varname       = "B2N"

filename      = casename+"_"+varname

nfs = 49

;tgthr = (/56,66,68,49,51,51,55,50,69,68/) ; from obs
;tgthr = (/58,65,68,49,55,60,60,50,69,72/)
tgthr = 58

mfs = dimsizes(tgthr)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

plot0 = new(7,graphic)
plot1 = new(7,graphic)
plot2 = new(7,graphic)

rr_tmp        = new((/mfs,nfs/),float)
b2n_tmp       = new((/mfs,nfs/),float)
b2s_tmp       = new((/mfs,nfs/),float)
b2d0_tmp      = new((/mfs,nfs/),float)
b2iorg_tmp    = new((/mfs,nfs/),float)
b2convpix_tmp = new((/mfs,nfs/),float)
b2strtpix_tmp = new((/mfs,nfs/),float)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

time           = new((/nfs/),double)

RR             = new((/nstart,nexp,nfs/),float)
B2N            = new((/nstart,nexp,nfs/),float)
B2S            = new((/nstart,nexp,nfs/),float)
B2D0           = new((/nstart,nexp,nfs/),float)
B2Iorg         = new((/nstart,nexp,nfs/),float)
B2CONVPIX      = new((/nstart,nexp,nfs/),float)
B2STRTPIX      = new((/nstart,nexp,nfs/),float)

RR_mnmx        = new((/3,nexp,nfs/),float)
B2N_mnmx       = new((/3,nexp,nfs/),float)
B2S_mnmx       = new((/3,nexp,nfs/),float)
B2D0_mnmx      = new((/3,nexp,nfs/),float)
B2Iorg_mnmx    = new((/3,nexp,nfs/),float)
B2CONVPIX_mnmx = new((/3,nexp,nfs/),float)
B2STRTPIX_mnmx = new((/3,nexp,nfs/),float)

wks1=gsn_open_wks(type,filename)
gsn_define_colormap(wks1,cmap)

do iexp   = 0 , 7

do istart = 0 , nstart-1

 starttime = startnamelist(istart)
 expname   = expnamelist(iexp)

 datafile  = addfile("./data/analysis/"+casename+"/start"+starttime+"/"+expname+".nc","r")

 rr        = datafile->RR
 b2n       = datafile->B2N
 b2s       = datafile->B2S
 b2d0      = datafile->B2D0
 b2iorg    = datafile->B2Iorg
 b2convpix = datafile->B2CONVPIX
 b2strtpix = datafile->B2STRTPIX

; rr(0,505)   = rr@_FillValue ; 15 Oct. 18 UTC
; b2n1(0,0:504)  = b2n0(0,0:504)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 do jfs = 0 , mfs-1
  do ifs = 0 , nfs-2
   tgtind = tgthr(jfs) * 12
   hrp = ((nfs-1)/2)*12 ; time resolution = 5 minutes
   rr_tmp(jfs,ifs)         = avg(rr(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2n_tmp(jfs,ifs)        = avg(b2n(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2s_tmp(jfs,ifs)        = avg(b2s(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2d0_tmp(jfs,ifs)       = avg(b2d0(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2iorg_tmp(jfs,ifs)     = avg(b2iorg(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2convpix_tmp(jfs,ifs)  = avg(b2convpix(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
   b2strtpix_tmp(jfs,ifs)  = avg(b2strtpix(jfs,tgtind-hrp+ifs*12:tgtind-hrp+ifs*12+11))
  end do
 end do

 rr_o        = dim_avg_n(rr_tmp,0)
 b2n_o       = dim_avg_n(b2n_tmp,0)
 b2s_o       = dim_avg_n(b2s_tmp,0)
 b2d0_o      = dim_avg_n(b2d0_tmp,0)
 b2iorg_o    = dim_avg_n(b2iorg_tmp,0)
 b2convpix_o = dim_avg_n(b2convpix_tmp,0)
 b2strtpix_o = dim_avg_n(b2strtpix_tmp,0)

 RR(istart,iexp,:)        = rr_o
 B2N(istart,iexp,:)       = b2n_o
 B2S(istart,iexp,:)       = b2s_o
 B2D0(istart,iexp,:)      = b2d0_o
 B2Iorg(istart,iexp,:)    = b2iorg_o
 B2CONVPIX(istart,iexp,:) = b2convpix_o
 B2STRTPIX(istart,iexp,:) = b2strtpix_o

end do ; istart

;RR(1:nexp-1,11) = RR(0,11)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

RR        = runave_n(RR,3,0,2)
B2N       = runave_n(B2N,3,0,2)
B2S       = runave_n(B2S,3,0,2)
B2D0      = runave_n(B2D0,3,0,2)
B2Iorg    = runave_n(B2Iorg,3,0,2)
B2CONVPIX = runave_n(B2CONVPIX,3,0,2)
B2STRTPIX = runave_n(B2STRTPIX,3,0,2)

RR_mnmx(0,iexp,:) = dim_avg_n(RR(:,iexp,:),0)
RR_mnmx(1,iexp,:) = RR_mnmx(0,iexp,:) - sqrt(dim_variance_n(RR(:,iexp,:),0))
RR_mnmx(2,iexp,:) = RR_mnmx(0,iexp,:) + sqrt(dim_variance_n(RR(:,iexp,:),0))

B2N_mnmx(0,iexp,:) = dim_avg_n(B2N(:,iexp,:),0)
B2N_mnmx(1,iexp,:) = B2N_mnmx(0,iexp,:) - sqrt(dim_variance_n(B2N(:,iexp,:),0))
B2N_mnmx(2,iexp,:) = B2N_mnmx(0,iexp,:) + sqrt(dim_variance_n(B2N(:,iexp,:),0))

B2S_mnmx(0,iexp,:) = dim_avg_n(B2S(:,iexp,:),0)
B2S_mnmx(1,iexp,:) = B2S_mnmx(0,iexp,:) - sqrt(dim_variance_n(B2S(:,iexp,:),0))
B2S_mnmx(2,iexp,:) = B2S_mnmx(0,iexp,:) + sqrt(dim_variance_n(B2S(:,iexp,:),0))

B2D0_mnmx(0,iexp,:) = dim_avg_n(B2D0(:,iexp,:),0)
B2D0_mnmx(1,iexp,:) = B2D0_mnmx(0,iexp,:) - sqrt(dim_variance_n(B2D0(:,iexp,:),0))
B2D0_mnmx(2,iexp,:) = B2D0_mnmx(0,iexp,:) + sqrt(dim_variance_n(B2D0(:,iexp,:),0))

B2Iorg_mnmx(0,iexp,:) = dim_avg_n(B2Iorg(:,iexp,:),0)
B2Iorg_mnmx(1,iexp,:) = B2Iorg_mnmx(0,iexp,:) - sqrt(dim_variance_n(B2Iorg(:,iexp,:),0))
B2Iorg_mnmx(2,iexp,:) = B2Iorg_mnmx(0,iexp,:) + sqrt(dim_variance_n(B2Iorg(:,iexp,:),0))

B2CONVPIX_mnmx(0,iexp,:) = dim_avg_n(B2CONVPIX(:,iexp,:),0)
B2CONVPIX_mnmx(1,iexp,:) = B2CONVPIX_mnmx(0,iexp,:) - sqrt(dim_variance_n(B2CONVPIX(:,iexp,:),0))
B2CONVPIX_mnmx(2,iexp,:) = B2CONVPIX_mnmx(0,iexp,:) + sqrt(dim_variance_n(B2CONVPIX(:,iexp,:),0))

B2STRTPIX_mnmx(0,iexp,:) = dim_avg_n(B2STRTPIX(:,iexp,:),0)
B2STRTPIX_mnmx(1,iexp,:) = B2STRTPIX_mnmx(0,iexp,:) - sqrt(dim_variance_n(B2STRTPIX(:,iexp,:),0))
B2STRTPIX_mnmx(2,iexp,:) = B2STRTPIX_mnmx(0,iexp,:) + sqrt(dim_variance_n(B2STRTPIX(:,iexp,:),0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

if (iexp.eq.0) then
; var            = True
; var@RR         = RR_mnmx(:,0:1,:)
; var@B2N        = B2N_mnmx(:,0:1,:)
; var@B2S        = B2S_mnmx(:,0:1,:)
; var@B2D0       = B2D0_mnmx(:,0:1,:)
; var@B2Iorg     = B2Iorg_mnmx(:,0:1,:)
; var@B2CONVPIX  = B2CONVPIX_mnmx(:,0:1,:)
; var@B2STRTPIX  = B2STRTPIX_mnmx(:,0:1,:)
 continue
end if

var            = True
var@RR         = RR_mnmx(:,0:iexp:iexp,:)
var@B2N        = B2N_mnmx(:,0:iexp:iexp,:)
var@B2S        = B2S_mnmx(:,0:iexp:iexp,:)
var@B2D0       = B2D0_mnmx(:,0:iexp:iexp,:)
var@B2Iorg     = B2Iorg_mnmx(:,0:iexp:iexp,:)
var@B2CONVPIX  = B2CONVPIX_mnmx(:,0:iexp:iexp,:)
var@B2STRTPIX  = B2STRTPIX_mnmx(:,0:iexp:iexp,:)

varlongname            = True
varlongname@RR         = "Rain rate (mm/hr)"
varlongname@B2N        = "N"
varlongname@B2S        = "CCE size (km~S~2~N~)"
varlongname@B2D0       = "D0"
varlongname@B2Iorg     = "Iorg"
varlongname@B2CONVPIX  = "Convective fraction (%)"
varlongname@B2STRTPIX  = "Stratiform fraction (%)"

vara = var@$varname$

vara@long_name = varlongname@$varname$

;;;;;;;;;;;;;;;;;;;;

resxy                             = True
resxy@gsnXYBarChart               = False
resxy@gsnDraw                     = False
resxy@gsnFrame                    = False
resxy@vpXF                        = 0.21
resxy@vpWidthF                    = 0.58 ; Set width and height of plot.
resxy@vpHeightF                   = 0.2
resxy@xyMonoLineThickness         = True
resxy@xyLineThicknessF            = 0.5
resxy@xyLineOpacities             = 0.5
resxy@xyDashPattern               = 0
resxy@trXMinF                     = -24.
resxy@trXMaxF                     =  24.
resxy@trYMinF                     =   0.
resxy@trYMaxF                     =   150.
;resxy@trYMinF                     =   0.4
;resxy@trYMaxF                     =   1.0
resxy@tmYLMinorOn                 = False
resxy@tmYLLabelFontHeightF        = 0.015
;resxy@tmYLLabelFontColor          = resxy@xyLineColor
resxy@tmYLMode                    = "Explicit"
;resxy@tmYLValues                  = fspan(0.4,0.9,6)
;resxy@tmYLLabels                  = resxy@tmYLValues
resxy@tmXBMode                    = "Explicit"
resxy@tmXBValues                  = ispan(-24,24,12)
;resxy@tmXBLabels                  = (/14,15,16,17,18/)
resxy@tmXBLabels                  = resxy@tmXBValues
resxy@tiXAxisString               = "time (date)"
resxy@tiYAxisString               = varlongname@$varname$
resxy@tiMainString                = expnamelist(1)
;resxy@tiYAxisFontColor            = resxy@xyLineColor
resxy@pmLegendDisplayMode         = "Never"
;resxy@pmLegendDisplayMode         = "Always"
resxy@pmLegendSide                = "Top" 
resxy@pmLegendParallelPosF        =   .85
resxy@pmLegendOrthogonalPosF      = -3. 
resxy@pmLegendWidthF              =  0.1
resxy@pmLegendHeightF             =  0.2
resxy@lgLabelFontHeightF          =   .015
resxy@lgPerimOn                   = False
;resxy@xyExplicitLegendLabels      = (/"control","homoQv","homoRth","homoT","homoUVbl","homoUVlt","homoUVut"/)
resxy@trYReverse                  = False

resxy@xyLineColors                = (/"Black","Blue"/)
;resxy@xyLineColors                = (/"Black",fillcolors(iexp-1)/)
resxy@xyDashPattern               = 0
resxy@xyLineThicknessF            = 2
resxy@xyLineOpacities             = 1
resxy@tiMainString                = expnamelist(iexp)

plot0(iexp-1) = gsn_csm_xy(wks1,fspan(-24,24,49),vara(0,0:1,:),resxy)

resxy@gsnXYFillColors = "Grey"
resxy@gsnXYFillOpacities = 0.8
resxy@xyLineColors     = (/-1,-1/)

plot1(iexp-1)  = gsn_csm_xy (wks1,fspan(-24,24,49),vara(1:2,0,:),resxy)


resxy@gsnXYFillColors = "LightBlue"
;resxy@gsnXYFillColors = fillcolors(iexp-1)
resxy@gsnXYFillOpacities = 0.8
resxy@xyLineColors     = (/-1,-1/)
plot2(iexp-1)  = gsn_csm_xy (wks1,fspan(-24,24,49),vara(1:2,1,:),resxy)

overlay(plot0(iexp-1),plot1(iexp-1))
overlay(plot0(iexp-1),plot2(iexp-1))

;draw(plot0)
;frame(wks1)

delete(resxy)

end do ; iexp

gsn_panel(wks1,plot0,(/4,2/),False)

end
