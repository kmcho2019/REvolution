module JC_counter (
    input  wire        clk,   // Clock signal for synchronous updates
    input  wire        rst_n, // Asynchronous active-low reset
    output reg  [63:0] Q      // 64-bit Johnson counter output
);

wire msb_in;

// The new MSB input is the inversion of the current LSB of Q
assign msb_in = ~Q[0];

// On the rising edge of clock or falling edge of reset:
// - If reset is asserted (low), clear Q to zero.
// - Otherwise, shift Q right by one bit and load msb_in at MSB position,
//   effectively implementing the Johnson counter sequence.
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        Q <= 64'b0;
    end else begin
        Q <= {msb_in, Q[63:1]};
    end
end

endmodule