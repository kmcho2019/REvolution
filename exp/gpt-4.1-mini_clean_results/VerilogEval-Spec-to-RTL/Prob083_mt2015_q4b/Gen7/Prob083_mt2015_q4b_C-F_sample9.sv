module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

// Procedural combinational logic: output z is high when x equals y (XNOR)
always @(*) begin
    z = ~(x ^ y);
end

endmodule