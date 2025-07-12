module JC_counter (
    input  wire        clk,    // Clock input
    input  wire        rst,    // Active-high synchronous reset
    output reg [63:0]  Q       // 64-bit Johnson counter output
);

wire [63:0] next_Q;
assign next_Q = {~Q[0], Q[63:1]};   // Compute next state by shifting right and inserting inverted LSB at MSB

// Enable updating Q only if next_Q differs from current Q
wire ce = (Q != next_Q);

always @(posedge clk) begin
    if (rst)
        Q <= 64'b0;   // Reset to zero synchronously
    else if (ce)
        Q <= next_Q;  // Update only when state changes
end

endmodule