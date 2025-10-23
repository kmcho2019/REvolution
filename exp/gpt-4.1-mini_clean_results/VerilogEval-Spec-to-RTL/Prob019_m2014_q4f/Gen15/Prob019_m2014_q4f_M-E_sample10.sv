module TopModule (
    input  wire in1,
    input  wire in2,
    output reg  out
);
    wire not_in2;

    // Invert in2 using continuous assignment
    assign not_in2 = ~in2;

    // Behavioral always_comb block to model AND of in1 and not_in2
    always @(*) begin
        out = in1 & not_in2;
    end

endmodule