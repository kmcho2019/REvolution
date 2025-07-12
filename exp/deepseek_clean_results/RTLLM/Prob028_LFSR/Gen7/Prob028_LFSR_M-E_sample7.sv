module LFSR (
    input clk,
    input rst,
    input feedback_sel,  // 0 for Fibonacci, 1 for Galois
    input invert_fb,     // Invert feedback signal
    input max_length,    // 1 for max-length sequence
    output reg [3:0] out // Current state
);

wire feedback;
reg [3:0] next_state;

// Dynamic feedback path selection
assign feedback = feedback_sel ? out[3] : (out[3] ^ out[2]);

// Configurable feedback inversion
wire processed_fb = invert_fb ? ~feedback : feedback;

// Mode selection logic
wire mode_mask = max_length ? 1'b1 : out[0];

always @(*) begin
    if (rst) begin
        next_state = 4'b0001; // Non-zero initial state
    end else begin
        // Circular shift with dynamic feedback
        next_state = {out[2:0], processed_fb & mode_mask};
    end
end

always @(posedge clk) begin
    out <= next_state;
end

endmodule