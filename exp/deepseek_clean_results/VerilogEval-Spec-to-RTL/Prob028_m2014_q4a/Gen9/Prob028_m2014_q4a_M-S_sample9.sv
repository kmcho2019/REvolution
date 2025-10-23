module TopModule(d, ena, q);
input d, ena;
output q;
assign q = ena ? d : q;
endmodule