module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    q <= q >> 1;   // Shift q right by one bit
    q[7] <= d;     // Insert new bit d into MSB
end

endmodule