module TopModule (
    input wire in1,
    input wire in2,
    input wire in3,
    output reg out
);

    always @(*) begin
        // XNOR is NOT XOR
        // Intermediate XNOR result of in1 and in2
        // Then XOR with in3 for output
        out = (~(in1 ^ in2)) ^ in3;
    end

endmodule