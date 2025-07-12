module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output reg out
);

    always @(*) begin
        // XNOR is equality check: (in1 == in2)
        // Then XOR with in3
        out = (in1 == in2) ^ in3;
    end

endmodule