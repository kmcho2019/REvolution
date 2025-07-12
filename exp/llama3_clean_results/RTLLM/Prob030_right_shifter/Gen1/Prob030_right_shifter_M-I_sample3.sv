module right_shifter(
    input clk,
    input d,
    output reg [7:0] q // Declare q as both output and reg here
);

always @(posedge clk)
begin
    if (q == 8'b0) // Initialize q if it's 0 (this could be removed if power-on reset is guaranteed)
        q <= 8'b0;
    q <= {d, q[7:1]}; // Shift right and insert d at MSB
end

endmodule