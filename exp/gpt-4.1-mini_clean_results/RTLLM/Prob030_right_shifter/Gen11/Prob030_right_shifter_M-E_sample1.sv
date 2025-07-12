module right_shifter (
    input  wire       clk,
    input  wire       rst_n,  // Active-low synchronous reset
    input  wire       d,
    output reg  [7:0] q
);

always @(posedge clk) begin
    if (!rst_n) begin
        q <= 8'b0;
    end else begin
        q <= q >> 1;  // Shift right by 1 bit
        q[7] <= d;    // Insert new bit at MSB
    end
end

endmodule