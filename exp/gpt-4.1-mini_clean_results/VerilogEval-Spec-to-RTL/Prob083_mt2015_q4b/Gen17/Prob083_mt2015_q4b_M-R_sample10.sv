module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

always @(*) begin
    // Assign z as bitwise XNOR of inputs x and y
    z = ~(x ^ y);
end

endmodule