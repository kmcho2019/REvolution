module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

always @(posedge clk) begin
    // Shift q right by one bit
    q <= q >> 1;
    // Insert new bit at MSB
    q[7] <= d;
end

endmodule