module TopModule(
    input in1,
    input in2,
    input in3,
    output reg out
);

always @(*) begin
    // Perform the XNOR operation between in1 and in2
    out = ~(in1 ^ in2) ^ in3;
end

endmodule