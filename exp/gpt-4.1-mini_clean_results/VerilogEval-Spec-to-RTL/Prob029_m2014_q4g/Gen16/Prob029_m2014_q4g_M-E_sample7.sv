module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output reg out
);
    reg xnor_result;

    always @(*) begin
        // Perform the two-input XNOR on in1 and in2
        xnor_result = ~(in1 ^ in2);
        // Perform XOR of the xnor_result with in3
        out = xnor_result ^ in3;
    end
endmodule