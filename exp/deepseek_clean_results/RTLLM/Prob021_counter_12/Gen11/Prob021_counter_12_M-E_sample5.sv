module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// State encoding
typedef enum logic [1:0] {
    RESET,
    COUNTING,
    HOLD
} state_t;

state_t current_state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= RESET;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case (current_state)
        RESET: begin
            out = 4'b0000;
            next_state = (valid_count) ? COUNTING : HOLD;
        end
        COUNTING: begin
            if (out == 4'd11) begin
                out = 4'b0000;
            end else begin
                out = out + 1'b1;
            end
            next_state = (valid_count) ? COUNTING : HOLD;
        end
        HOLD: begin
            out = out;  // Maintain current value
            next_state = (valid_count) ? COUNTING : HOLD;
        end
        default: begin
            out = 4'b0000;
            next_state = RESET;
        end
    endcase
end

endmodule