module TopModule (
    input  in1,
    input  in2,
    output reg out
);
    always @(*) begin
        // Invert in2 (bubble) and AND with in1
        out = in1 & (~in2);
    end
endmodule