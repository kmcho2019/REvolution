module TopModule(
    input  d,
    input  ena,
    output reg q
);
    
assign q = ena ? d : q;

endmodule