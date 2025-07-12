module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

// Procedural combinational block to assign z
// z is high when inputs x and y are equal, implementing XNOR logic.
always @(*) begin
    if (x == y)
        z = 1'b1;
    else
        z = 1'b0;
end

endmodule