// Novel 4-bit LFSR module using a state machine
module LFSR(
    input           clk,  // Clock signal
    input           rst,  // Active high reset signal
    output reg [3:0] out  // 4-bit output representing the current state of the LFSR
);

// Enumerate the states of the state machine
enum logic [1:0] {
    IDLE,
    SHIFT,
    FEEDBACK
} state, next_state;

// Handle the clock edge and reset conditions
always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        out <= 4'b0;  // Reset to zero
    end else begin
        state <= next_state;
        case (state)
            IDLE: begin
                if (~out[3] && ~out[2]) begin
                    next_state <= SHIFT;
                end else begin
                    next_state <= IDLE;
                end
            end
            SHIFT: begin
                out <= {out[2:0], ~^(out[3] ^ out[2])};  // Simplified feedback calculation
                next_state <= FEEDBACK;
            end
            FEEDBACK: begin
                next_state <= IDLE;
            end
            default: begin
                next_state <= IDLE;
            end
        endcase
    end
end

endmodule