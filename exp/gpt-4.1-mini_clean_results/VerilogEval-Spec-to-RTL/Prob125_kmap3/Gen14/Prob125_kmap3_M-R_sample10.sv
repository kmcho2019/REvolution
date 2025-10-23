module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output reg out
);

wire nb;        // negated b
wire c_and_nb;  // c & ~b

assign nb = ~b;
assign c_and_nb = c & nb;

always @(*) begin
    out = a | c_and_nb;
end

endmodule