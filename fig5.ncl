load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin

homedir="/global/cscratch1/sd/wycheng/"

cmap = (/ (/255.,255.,255./),(/  0.,  0.,  0./),\
          (/255.,255.,255./),(/ 29.,  0.,255./),(/126.,229., 91./),\
\;          (/ 78.,204., 67./),(/ 46.,178., 57./),(/ 30.,153., 61./),\
          (/ 46.,178., 57./),(/ 30.,153., 61./),\
          (/255.,255.,102./),(/255.,204.,102./),(/255.,136., 76./),\
          (/255., 25., 25./),(/204., 61., 61./),(/165., 49., 49./),\
          (/237.,  0.,237./),(/137.,103.,205./) /)/255.

type = "x11"

;imax   = 300
;jmax   = 300
;xstart = -149.5
;ystart = -149.5
;dx     = 1.
;dy     = 1.

figtype = "WRF_SCM"
starttime = "2011101400"
;casename = "mp08_6th"
casename = "mp08_6th_homoNCQv_tau600s"

D          = new((/1000/),float)
B2NND      = new((/1000/),float)
B2NNCDFobs = new((/99/),float)
x          = fspan(0.01,0.99,99)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

file0 = addfile(homedir+"WRF-SCM/DYNAMO/1014/ensemble/start2011101400/mp08_6th/wrfout/wrfout_d01_2011-10-14_00:00:00","r")

PHB = file0->PHB(0,:,0,0) ; 63
PB  = file0->PB(0,:,0,0) ; 62

level = new((/62/),float)
rho = new((/62/),float)

do ik = 0 , 61
  level(ik) = (PHB(ik)+PHB(ik+1))/2
end do

do ik = 1 , 60
  rho(ik)   = (PB(ik-1)-PB(ik+1))/(level(ik+1)-level(ik-1))
end do

rho( 0) = rho(2)  + (rho( 1)-rho( 2))*((level( 2)-level( 0))/(level( 1)-level( 0)))
rho(61) = rho(59) - (rho(59)-rho(60))*((level(61)-level(59))/(level(60)-level(59)))

level = level/9.8

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

do YYYY = 2011,2011
do   MM =   10,  10
do   DD =   16,  16
do   hh =   15,  15
do   mm =    5,   5, 5


 print(YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")

 file1   = homedir+"WRF-SCM/DYNAMO/1014/ensemble/start"+starttime+"/"+casename+"/coldpool/coldpool_d01_"+YYYY+"-"+MM+"-"+sprinti("%0.2i",DD)+"_"+sprinti("%0.2i",hh)+":"+sprinti("%0.2i",mm)+":00.nc"

; file2   = SHY95 raintype file

 file3   = homedir+"data/raintype_PHB16_WRF_legacy_SCM/1014/ensemble/start"+starttime+"/"+casename+"/raintype_coldpool_d01_"+YYYY+"-"+MM+"-"+sprinti("%0.2i",DD)+"_"+sprinti("%0.2i",hh)+":"+sprinti("%0.2i",mm)+":00.nc"

; file4   = SHY95 CCE file

 file5   = homedir+"data/blob_PHB16_WRF_legacy_24_SCM/1014/ensemble/start"+starttime+"/"+casename+"/blob_spol_qc."+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00.nc"
 
;file6    = CCU file

; file7   = "/scratch2/scratchdirs/wycheng/data/tracking/WRF_SCM/1014/ensemble/start"+starttime+"/"+casename+"/tracking_blob."+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00.nc"

 iostat1 = isfilepresent(file1)
; iostat2 = isfilepresent(file2)
 iostat3 = isfilepresent(file3)
; iostat4 = isfilepresent(file4)
 iostat5 = isfilepresent(file5)
; iostat6 = isfilepresent(file6)
; iostat7 = isfilepresent(file7)

 jump = 0

 if (.not.iostat1) then
;  print("missing files (WRF coldpool_d01) : "+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
  print(file1)
  jump = 1
 end if

; if (.not.iostat2) then
; print("missing files (SHY95 rain type) : "+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
;  jump = 1
; end if

 if (.not.iostat3) then
 print("missing files (PHB16 rain type) : "+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
  jump = 1
 end if

; if (.not.iostat4) then
; print("missing files (SHY95 CCE) : "+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
;  jump = 1
; end if

 if (.not.iostat5) then
 print("missing files (PHB16 CCE) : "+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
  jump = 1
 end if

; if (.not.iostat6) then
; print("missing files (CCU file) : "+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
;  jump = 1
; end if

; if (.not.iostat7) then
; print("missing files (tracking_PHB16) : "+YYYY+""+MM+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
;  jump = 1
; end if

 if (jump .eq. 1) then
  continue
 end if

 cdplfile        = addfile(file1,"r")
; csfile1         = addfile(file2,"r")
 csfile2         = addfile(file3,"r")
; blobfile1       = addfile(file4,"r")
 blobfile2       = addfile(file5,"r")
; updtfile        = addfile(file6,"r")
; trckfile        = addfile(file7,"r")

 T    = cdplfile->T(0,20,:,:)

; nb1  = blobfile1->BLOB_NUMBER
; id1  = blobfile1->BLOB_ID(:,:)
; ar1  = blobfile1->AREA(:,:)
; ed1  = blobfile1->EDGE(:,:)
; bs1  = blobfile1->BLOB_SIZE(:)
; bcx1 = blobfile1->BLOB_CENTERX(:)
; bcy1 = blobfile1->BLOB_CENTERY(:)
; be1  = blobfile1->BLOB_EDGE(:)
; bdi1 = blobfile1->BLOB_DIAMETER(:)
; caf1 = blobfile1->CONVPIX
; saf1 = blobfile1->STRTPIX

 nb2  = blobfile2->BLOB_NUMBER
 id2  = blobfile2->BLOB_ID(:,:)
 ar2  = blobfile2->AREA(:,:)
 ed2  = blobfile2->EDGE(:,:)
 bs2  = blobfile2->BLOB_SIZE(:)
 bcx2 = blobfile2->BLOB_CENTERX(:)
 bcy2 = blobfile2->BLOB_CENTERY(:)
 be2  = blobfile2->BLOB_EDGE(:)
 bdi2 = blobfile2->BLOB_DIAMETER(:)
 d02  = blobfile2->BLOB_D0
 caf2 = blobfile2->CONVPIX
 saf2 = blobfile2->STRTPIX

; ntcce = trckfile->NTCCE(0,:,:)
; dying = trckfile->DYING(0,:,:)
; merge = trckfile->MERGE(0,:,:)
; split = trckfile->SPLIT(0,:,:)

;;;;;;;;;;;;;;;;;;;;;;;;;

 B2NND = B2NND@_FillValue
 do i = 0 , nb2-1
  D = 9999.
  do j = 0 , nb2-1
   if (i.eq.j) then
    continue
   end if
   D(j) = ((bcx2(i)-bcx2(j))^2.+(bcy2(i)-bcy2(j))^2.)^0.5
  end do
  if (min(D).eq.9999.) then
   continue
  end if
  B2NND(i) = min(D)
 end do

 if (nb2.le.1) then
  Iorg = -9999.
 else
  r = (((-256.*256.)/(3.14*nb2))*log((1-x)))^0.5
  B2NNCDFobs  = 0
  do i = 0 , 98
   B2NNCDFobs(i) = tofloat(num(B2NND(0:nb2-1).le.r(i)))/tofloat(nb2)
  end do
  Iorg = simpeq(B2NNCDFobs,0.01)
 end if


;;;;;;;;;;;;;;;;;;;;;;;;;

 db  = (/cdplfile->REFL_10CM(0,20,:,:)/) ; 2.5 km
; db  = (/cdplfile->REFL_10CM(0,12,:,:)/) ; 1 km

 w_tmp = (/cdplfile->W(0,:,:,:)/)

 
 w = w_tmp(0,:,:)
 w = 0

 do ik = 12 , 20
  w(:,:) = w(:,:) + w_tmp(ik,:,:)*rho(ik)
 end do

 w(:,:) = w(:,:)/sum(rho(12:20))

; cs1  = convsffile1->convsf(0,0,:,:)
 cs2  = (/csfile2->rain_type(0,:,:)/)

; db  = db  * ar2
; w   =  w  * ar2
; T   = T   * ar2
; cs1 = cs1 * ar2
; cs2 = cs2 * ar2

 db!0 = id2!0
 db!1 = id2!1
 w!0 = id2!0
 w!1 = id2!1
; T!0 = id2!0
; T!1 = id2!1
; cs1!0 = id2!0
; cs1!1 = id2!1
 cs2!0 = id2!0
 cs2!1 = id2!1
; updt_id!0 = id2!0
; updt_id!1 = id2!1
; ntcce!0 = id2!0
; ntcce!1 = id2!1
; merge!0 = id2!0
; merge!1 = id2!1
; dying!0 = id2!0
; dying!1 = id2!1
; split!0 = id2!0
; split!1 = id2!1


 db&x = id2&x
 db&y = id2&y
 w&x = id2&x
 w&y = id2&y
; T&x = id2&x
; T&y = id2&y
; cs1&x = id2&x
; cs1&y = id2&y
 cs2&x = id2&x
 cs2&y = id2&y
; updt_id&x = id2&x
; updt_id&y = id2&y
; ntcce&x = id2&x
; ntcce&y = id2&y
; merge&x = id2&x
; merge&y = id2&y
; dying&x = id2&x
; dying&y = id2&y
; split&x = id2&x
; split&y = id2&y



res                        = True
res@cnFillOn               = True
res@lbLabelBarOn           = True
;res@gsnSpreadColors        = True
res@gsnDraw                = False
res@gsnFrame               = False
res@tmXBValues             = ispan(-150,150,50)
res@tmYLValues             = ispan(-150,150,50)
res@tmXBLabels             = res@tmXBValues
res@tmYLLabels             = res@tmYLValues
res@cnConstFLabelFontHeightF = 0.0 
;res@trXMinF                  =  0
;res@trXMaxF                  =  100
;res@trYMinF                  =  -150 
;res@trYMaxF                  =  -50

res@cnLevelSelectionMode   = "ExplicitLevels"

res1=res
res2=res
res31=res
res32=res
res4=res
res5=res

resxy                       = True
resxy@gsnXYBarChart         = True
resxy1=resxy
resxy2=resxy
resxy3=resxy
resxy4=resxy
resxy5=resxy
resxy61=resxy
resxy62=resxy
resxy7=resxy

polyres               = True          ; poly marker mods desired 
polyres@gsMarkerIndex = 16            ; choose circle as polymarker
polyres@gsMarkerSizeF = 10.0           ; select size to avoid streaking
polyres@gsMarkerColor = (/"white"/)   ; choose color

txres                       = True                            
txres@txBackgroundFillColor = (/"white"/)
txres@txFontColor           = (/"black"/)
txres@txFontHeightF         = 0.02             ; Set the font height

;db_temp=db
;id_temp=id
;ar_temp=ar
;ed_temp=ed
;
;do i = 0,imax-1
; do j = 0 ,jmax-1
;  if (ismissing(db_temp(i,j))) then
;    db_temp(i,j)=0
;   else if (db_temp(i,j).eq.-9999) then
;    db_temp(i,j)=0
;   end if
;  end if
;  if (id_temp(i,j).lt.-1) then
;   id_temp(i,j)=0
;  end if
;  if (ar_temp(i,j).lt.-1) then
;   ar_temp(i,j)=0
;  end if
;  if (ed_temp(i,j).lt.-1) then
;   ed_temp(i,j)=0
;  end if
; end do
;end do

;nid=floattointeger(max(id_temp))
;levs   = ispan(1,nid,1)
;labels = tostring(levs)

;;;;;;;;;;;;;;  area  ;;;;;;;;;;;;;;;;;;;;

;wks1=gsn_open_wks(type,"area_"+enddate+"."+endtime)
;gsn_define_colormap(wks1,cmap)
res1@cnLinesOn              = True
res1@cnFillOn               = False
res1@cnLevels               = (/.5/)
res1@cnLineThicknessF       = 5.
res1@cnLineLabelsOn         = False
res1@cnInfoLabelOn          = False
res1@gsnLeftString          = ""
;plot1   = gsn_csm_contour(wks1,ar1(:,:),res1)
;draw(plot1)
;frame(wks1)

;;;;;;;;;;;;;;  dbz  ;;;;;;;;;;;;;;;;;;

db = where(id2.ge.1, 101, db)

;db_shift = db
;db_shift(0:100,:) = db(155:255,:) ; y
;db_shift(101:255,:) = db(0:154,:) ; y
;db = db_shift
;bcy2 = where(bcy2.lt.27, bcy2+100, bcy2-155)

;;;db_shift = db
;;;db_shift(:,0:127) = db(:,128:255) ; x
;;;db_shift(:,128:255) = db(:,0:127) ; x
;;;db = db_shift

db!0 = id2!0
db!1 = id2!1
db&x = id2&x
db&y = id2&y

cmap2 = (/(/255.,255.,255./),(/  0.,  0.,  0./),\
          (/255.,255.,255./),(/220.,220.,220./),(/162.,162.,162./),\
          (/  0.,  0.,  0./) /)/255.

wks2=gsn_open_wks(type,"reflectivities_"+casename+"_"+YYYY+""+sprinti("%0.2i",MM)+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00")
gsn_define_colormap(wks2,cmap2)
;gsn_define_colormap(wks2,"MPL_Oranges")
;gsn_define_colormap(wks2,"MPL_Greys")

res2@cnLinesOn              = False
res2@cnFillOn               = True
res2@cnFillMode             = "CellFill"
;res2@cnLevels               = ispan(5,40,5)
res2@cnLevels               = (/20,30, 100/)
;res2@cnLevels               = ispan(-4,4,1)
res2@cnLineLabelsOn         = False
res2@gsnSpreadColors        = True
res2@gsnSpreadColorStart    = 2
res2@gsnSpreadColorEnd      = 5
res2@lbOrientation          = "vertical"
res2@gsnLeftString          = ""
res2@gsnRightString         = "N = "+sprinti("%0.3i",nb2)+", D0 = "+sprintf("%6.2f",d02)+", Iorg = "+sprintf("%4.2f",Iorg)
res2@tiMainString = YYYY+""+sprinti("%0.2i",MM)+""+sprinti("%0.2i",DD)+"."+sprinti("%0.2i",hh)+""+sprinti("%0.2i",mm)+"00"
;res2@tiMainString = "Reflectivity"
;db = db * ar1

plot2     = gsn_csm_contour(wks2,db(:,:),res2)

;plot2     = gsn_csm_contour(wks2,w(:,:),res2)

;plot1     = gsn_csm_contour(wks2,ar1(:,:),res1)
;overlay(plot2,plot1)
;draw(plot2)
;frame(wks2)

;;;;;;;  convective straiform (SHY95)  ;;;;;;;;;;;

;wks31=gsn_open_wks(type,"rain_type_SHY95_"+enddate+"."+endtime)
;gsn_define_colormap(wks31,cmap)
res31@cnLinesOn                = False
res31@cnFillOn                 = True
res31@cnFillMode               = "CellFill"
res31@cnLevels                 = (/0.5,1.5,2.5/)
res31@cnLineLabelsOn           = False
res31@cnFillColors             = (/cmap(0,:),cmap(6,:),cmap(7,:),cmap(8,:)/)
res31@gsnLeftString            = ""
res31@gsnRightString           = ""
res31@lbLabelBarOn           = False
res31@cnInfoLabelOn          = False
res31@lbOrientation          = "vertical"
;res31@tiMainString = "rain type (SHY95) - "+enddate+"."+endtime
res31@tiMainString = "Rain type (SHY95)"
;cs1 = cs1 * ar1
;plot31  = gsn_csm_contour(wks31,cs1(:,:),res31)
;plot1   = gsn_csm_contour(wks31,ar1(:,:),res1)
;overlay(plot31,plot1)
;draw(plot31)
;frame(wks31)


;;;;;;;  convective straiform (PHB16)  ;;;;;;;;;;;

cmap1 = (/(/255,255,255/),(/0,0,0/),(/255,255,255/),(/255,25,25/)/)/255

;cs = where(cs.eq.3,4,cs)
;cs = where(cs.eq.1,-1,cs)
;cs = where(cs.eq.2,1,cs)

;cs2 = where((cs2.eq.2).or.(cs2.eq.4),1,0)
;cs = where((cs.eq.4).or.(cs.eq.5),3,cs)
;cs = where(cs.eq.6,4,cs)

;wks32=gsn_open_wks(type,"rain_type_PHB16_"+enddate+"."+endtime)
;gsn_define_colormap(wks32,cmap)
res32@cnLinesOn                = False
res32@cnFillOn                 = True
res32@cnFillMode               = "CellFill"
res32@cnLevels                 = (/0.5,1.5,2.5,3.5,4.5,5.5/)
res32@cnLineLabelsOn           = False
res32@cnFillColors             = (/cmap(0,:),cmap(6,:),cmap(7,:),cmap(9,:),cmap(13,:),cmap(14,:),cmap(8,:)/)
;res32@gsnSpreadColors          = True
res32@gsnLeftString            = ""
res32@gsnRightString           = ""
res32@lbLabelBarOn           = False
res32@cnInfoLabelOn          = False
res32@lbOrientation          = "vertical"
;res32@tiMainString = "rain type (PHB16) - "+enddate+"."+endtime
res32@tiMainString = "Rain type (PHB16)"
;cs2 = cs2 * ar1
;plot32  = gsn_csm_contour(wks32,cs2(:,:),res32)
;plot1   = gsn_csm_contour(wks32,ar1(:,:),res1)
;overlay(plot32,plot1)
;draw(plot32)
;frame(wks32)

;;;;;;;;;;;;;;  blob id  ;;;;;;;;;;;;;;

;id1&x = db&x
;id1&y = db&y

id_tmp = tofloat(id2)

;id_tmp = where(id1.ge.1,1,0)
id_tmp = where(id2.ge.1,2,id_tmp)

id_tmp_shift = id_tmp
id_tmp_shift(0:100,:) = id_tmp(155:255,:)
id_tmp_shift(101:255,:) = id_tmp(0:154,:)
id_tmp = id_tmp_shift

id_tmp!0 = "y"
id_tmp!1 = "x"
id_tmp&x = db&x
id_tmp&y = db&y




cmap4 = (/(/255,255,255/),(/0,0,0/),(/255,255,255/),(/0,0,255/),(/255,0,0/)/)/255
;wks4=gsn_open_wks(type,"blob_id_"+enddate+"."+endtime)
;gsn_define_colormap(wks4,cmap4)
;gsn_merge_colormaps(wks4,cmap4,"default")
res4@cnLinesOn                = True
res4@cnLineThicknessF         = 3.0
res4@cnFillOn                 = False
;res4@cnFillMode               = "CellFill"
res4@cnLevels                 = (/0.5/)
res4@cnLineLabelsOn           = False
res4@cnMonoLineColor          = True
res4@cnLineColor              = (/0,0,0/)/255.
;res4@cnLevels                 =  levs
;res4@tiMainString             = "blob id - "+enddate+"."+endtime
;res4@tiMainString             = "CCE"
res4@lbLabelBarOn             = False
res4@cnInfoLabelOn            = False
;res4@lbOrientation            = "vertical"
;res4@lbLabelConstantSpacingF  = 2.0
;id_tmp = id_tmp*ar1

plot41 = gsn_csm_contour(wks2,id_tmp(:,:),res4)


res42 = res4
res42@cnLineColor     = (/0,255,0/)/255.

;plot42 = gsn_csm_contour(wks2,ntcce(:,:),res42)

res43 = res4
res43@cnLineColor     = (/0,0,255/)/255.

w1 = w
w1 = where(w.ge.3,1,0)
plot43 = gsn_csm_contour(wks2,w1(:,:),res43)

;plot1 = gsn_csm_contour(wks4,ar1(:,:),res1)

;overlay(plot2,plot41)
;overlay(plot2,plot42)
;overlay(plot2,plot43)

pmres = True
pmres@gsMarkerColor = "black"
pmres@gsMarkerIndex = 1
pmres@gsMarkerSizeF = 0.04

;dum = gsn_add_polymarker(wks2, plot2, bcx2, bcy2, pmres)

draw(plot2)
frame(wks2)

;gsn_polymarker(wks4,plot4,bcx,bcy,polyres)  ; draw polymarkers
;text = gsn_add_text(wks4,plot4,labels,bcx(0:nid-1)-7,bcy(0:nid-1),txres)
;draw(plot4)
;frame(wks4)

;;;;;;;;;;;;;;;  edge  ;;;;;;;;;;;;;;;;;;;

;res5@cnLevels              = (/0,0.5,1.0/)
;plot   = gsn_csm_contour(wks,ed(:,:),res5)

;;;;;;;;;;;;;;;  blob size  ;;;;;;;;;;;;;;

;wks61=gsn_open_wks(type,"blob_size_SHY95_"+enddate+"."+endtime)
;gsn_define_colormap(wks61,"default")
resxy61@tiMainString = "CCE size SHY95"
resxy61@tiYAxisString = "size ( km~S~2~N~)"
resxy61@tiXAxisString = "CCE id"
resxy61@trYMinF       = 0
resxy61@gsnXYBarChartColors = 6
;resxy61@gsnXYBarChartColors = ispan(2,nb1-1,1)
resxy61@gsnXYBarChartBarWidth = 0.75
resxy61@tmXBFormat    = "f"

;bs1_sort = bs1
;qsort(bs1_sort)
;plot61  = gsn_csm_xy(wks61,ispan(1,nb1,1),bs1_sort(299-nb1+1:299),resxy61)

;wks62=gsn_open_wks(type,"blob_size_PHB16_"+enddate+"."+endtime)
;gsn_define_colormap(wks62,"default")
resxy62@tiMainString = "CCE size PHB16"
resxy62@tiYAxisString = "size ( km~S~2~N~)"
resxy62@tiXAxisString = "CCE id"
resxy62@trYMinF       = 0
resxy62@gsnXYBarChartColors = 6
;resxy62@gsnXYBarChartColors = ispan(2,nb2-1,1)
resxy62@gsnXYBarChartBarWidth = 0.75
resxy62@tmXBFormat    = "f"

;bs2_sort = bs2
;qsort(bs2_sort)
;plot62  = gsn_csm_xy(wks62,ispan(1,nb2,1),bs2_sort(999-nb2+1:999),resxy62)

;;;;;;;;;;;;;;  blob mean dist  ;;;;;;;;;;

;wks7=gsn_open_wks(type,"blob_mean_distance_"+date+"."+time)
;gsn_define_colormap(wks7,cmap)
;ress2@tiMainString = "blob mean distance"
;plot  = gsn_csm_xy(wks7,ispan(1,nid,1),bd1(0:nid-1),ress2)

;;;;;;;;;;;;;  blob mean dist 2  ;;;;;;;;;

;wks8=gsn_open_wks(type,"blob mean distance 2 - "+time)
;gsn_define_colormap(wks8,cmap)
;ress3@tiMainString = "blob mean distance2"
;plot  = gsn_csm_xy(wks8,ispan(1,nid,1),bd2(0:nid-1),ress3)

;;;;;;;;;;;;;;  blob edge  ;;;;;;;;;;;;;;;

;wks9=gsn_open_wks(type,"blob edge - "+time)
;gsn_define_colormap(wks9,cmap)
;ress4@tiMainString = "blob edge"
;plot  = gsn_csm_xy(wks9,ispan(1,nid,1),be(0:nid-1),ress4)

;;;;;;;;;;;;;  blob diameter  ;;;;;;;;;;;;

;wks10=gsn_open_wks(type,"blob_diameter-"+date+"."+time)
;gsn_define_colormap(wks10,cmap)
;resxy5@trYMaxF      = 10
;resxy5@trYMinF      = 0
;resxy5@tiMainString = "blob diameter "+date+"."+time
;plot  = gsn_csm_xy(wks10,ispan(1,nid,1),bdi(0:nid-1),resxy5)

;delete(levs)
;delete(labels)

end do ; mm
end do ; hh
end do ; DD
end do ; MM
end do ; YYYY

end
