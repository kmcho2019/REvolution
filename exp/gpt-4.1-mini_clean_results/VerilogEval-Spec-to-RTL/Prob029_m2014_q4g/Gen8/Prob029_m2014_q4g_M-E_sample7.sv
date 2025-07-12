module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output reg out
);
    reg xnor_val;

    always @(*) begin
        // XNOR operation by equality check
        xnor_val = (in1 == in2);
        // XOR of xnor_val and in3
        out = xnor_val ^ in3;
    end

endmodule