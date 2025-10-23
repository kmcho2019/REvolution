module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

always @(*) begin
    // Output z is high when inputs x and y are equal.
    // Implemented combinationally in an always block.
    if (x == y)
        z = 1'b1;
    else
        z = 1'b0;
end

endmodule