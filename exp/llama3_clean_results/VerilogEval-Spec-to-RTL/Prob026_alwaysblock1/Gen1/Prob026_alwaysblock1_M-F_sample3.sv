module TopModule(
    input  a,
    input  b,
    output reg out_assign, // Declare as reg for compatibility, though assign statement makes it behave like a wire
    output reg out_alwaysblock // Declare as reg because it's being assigned within an always block
);

// Using continuous assignment statement for AND gate
assign out_assign = a & b;

// Using combinational always block for AND gate
always @(*) begin
    out_alwaysblock = a & b;
end

endmodule