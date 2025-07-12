module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output reg out
);
    reg xnor_val;

    always @(*) begin
        // Compute XNOR of in1 and in2
        xnor_val = ~(in1 ^ in2);
        // XOR with in3 to produce output
        out = xnor_val ^ in3;
    end

endmodule