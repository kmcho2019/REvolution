module counter_12 (
    input wire rst_n,          // Active low reset
    input wire clk,            // Clock signal
    input wire valid_count,    // Enable counting when high
    output reg [3:0] out       // 4-bit counter output
);

// FSM states
typedef enum logic [1:0] {
    IDLE  = 2'b00,
    COUNT = 2'b01,
    WRAP  = 2'b10,
    HOLD  = 2'b11
} state_t;

state_t current_state, next_state;

// Predictive wrap detection
wire will_wrap = (out == 4'd10) & valid_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        out <= 4'b0000;
    end else begin
        current_state <= next_state;
        
        // State-specific operations
        case (current_state)
            IDLE:  out <= 4'b0000;
            COUNT: out <= out + 1'b1;
            WRAP:  out <= 4'b0000;
            HOLD:  out <= out; // Explicit hold for clarity
        endcase
    end
end

// Next state logic
always_comb begin
    case (current_state)
        IDLE:  next_state = valid_count ? COUNT : IDLE;
        COUNT: next_state = will_wrap ? WRAP : 
                           (valid_count ? COUNT : HOLD);
        WRAP:  next_state = valid_count ? COUNT : HOLD;
        HOLD:  next_state = valid_count ? COUNT : HOLD;
        default: next_state = IDLE;
    endcase
end

endmodule