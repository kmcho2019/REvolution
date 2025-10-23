module TopModule(
    input  in1,
    input  in2,
    input  in3,
    output reg out
);

always @(*) begin
    // The XNOR of in1 and in2 can be represented as ~(in1 ^ in2)
    // The XOR of this result with in3 gives the final output
    out = ~(in1 ^ in2) ^ in3;
end

endmodule