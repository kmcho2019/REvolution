module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output reg out
);

    reg xnor_out;

    always @(*) begin
        // Compute 2-input XNOR of in1 and in2
        xnor_out = ~(in1 ^ in2);
        // XOR the intermediate result with in3 to produce out
        out = xnor_out ^ in3;
    end

endmodule