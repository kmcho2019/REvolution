module JC_counter (
    input  wire       clk,    // Clock input
    input  wire       rst_n,  // Active-low asynchronous reset
    output reg [63:0] Q       // 64-bit Johnson counter output
);

// On each clock rising edge or asynchronous reset falling edge,
// update Q as per Johnson counter behavior:
// - If reset is asserted (rst_n == 0), clear Q to zero
// - Else shift right by 1 bit and insert inverted Q[0] into MSB
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        Q <= 64'b0;
    else
        Q <= {~Q[0], Q[63:1]};
end

endmodule