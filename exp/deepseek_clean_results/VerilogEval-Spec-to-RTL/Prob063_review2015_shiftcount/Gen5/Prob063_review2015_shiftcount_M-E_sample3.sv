module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

// Internal signals
wire [3:0] next_q_shift = {q[2:0], data};  // Shift operation
wire [3:0] next_q_count = q ^ 4'b0001;     // XOR-based decrement (LSB toggle)
wire [3:0] next_q_load  = 4'b0000;         // Parallel load (unused but available)
wire [3:0] next_q;

// Operation selection mux
assign next_q = (shift_ena) ? next_q_shift :
                (count_ena) ? next_q_count :
                q;                         // Default hold

always @(posedge clk) begin
    q <= next_q;
end

endmodule