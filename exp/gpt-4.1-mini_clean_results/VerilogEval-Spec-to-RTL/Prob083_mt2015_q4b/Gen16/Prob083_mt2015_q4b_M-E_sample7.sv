module TopModule (
    input  wire x,
    input  wire y,
    output reg  z
);

wire xor_xy;

always @* begin
    // XOR output high when inputs differ
    z = ~ (x ^ y);
end

endmodule