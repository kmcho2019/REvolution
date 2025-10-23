module TopModule (
    input  in1,
    input  in2,
    output reg out
);

wire inv_in2;

assign inv_in2 = ~in2;

always @(*) begin
    out = in1 & inv_in2;
end

endmodule