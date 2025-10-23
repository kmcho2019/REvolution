module TopModule(input d, ena, output q);
assign q = ena ? d : q;
endmodule