module TopModule(d, ena, q);
input d, ena;
output reg q;
always @(ena or d) if (ena) q = d;
endmodule