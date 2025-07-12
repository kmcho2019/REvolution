module TopModule (
    input  a,
    input  b,
    output reg out
);

    // Temporary wire to hold the nor primitive output
    wire nor_out;

    // Instantiate the built-in nor primitive
    nor (nor_out, a, b);

    // Combinational always block assigns nor primitive output to reg output
    always @(*) begin
        out = nor_out;
    end

endmodule