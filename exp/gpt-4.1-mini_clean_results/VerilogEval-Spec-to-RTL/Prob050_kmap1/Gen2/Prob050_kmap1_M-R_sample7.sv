module TopModule(
    input  a,
    input  b,
    input  c,
    output reg out
);

// Combinational logic implemented inside an always block.
// Output is 1 if any input is 1, else 0.
always @(*) begin
    if (a || b || c)
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule