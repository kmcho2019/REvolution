module TopModule (
    input in1,
    input in2,
    input in3,
    output reg out
);

    always @(*) begin
        // First perform XNOR between in1 and in2
        // Then XOR the result with in3
        out = (~(in1 ^ in2)) ^ in3;
    end

endmodule