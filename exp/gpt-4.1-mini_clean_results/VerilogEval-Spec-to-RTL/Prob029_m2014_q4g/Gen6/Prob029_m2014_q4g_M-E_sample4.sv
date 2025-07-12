module TopModule (
    input in1,
    input in2,
    input in3,
    output reg out
);

    reg xnor_result;

    always @(*) begin
        xnor_result = ~(in1 ^ in2); // XNOR operation
        out = xnor_result ^ in3;    // XOR with in3
    end

endmodule