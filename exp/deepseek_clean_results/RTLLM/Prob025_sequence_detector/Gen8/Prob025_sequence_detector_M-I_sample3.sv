module sequence_detector (
    input clk,
    input reset_n,
    input data_in,
    output reg sequence_detected
);

// Optimized state encoding
typedef enum logic [1:0] {
    IDLE = 2'b00,
    GOT1 = 2'b01,   // Received '1'
    GOT10 = 2'b10   // Received '10'
} state_t;

state_t current_state, next_state;
reg detected_reg;

// Clock gating control
wire clk_enable = (current_state != IDLE) || (data_in == 1'b1);

// State transition logic
always_comb begin
    next_state = current_state;
    case (current_state)
        IDLE: if (data_in == 1'b1) next_state = GOT1;
        GOT1: begin
            if (data_in == 1'b0) next_state = GOT10;
            else next_state = GOT1;  // Stay if we get consecutive 1s
        end
        GOT10: begin
            if (data_in == 1'b0) next_state = IDLE;  // '100' - reset
            else next_state = IDLE;  // Will detect on next clock
        end
    endcase
end

// Output detection logic
always_comb begin
    detected_reg = 1'b0;
    if (current_state == GOT10 && data_in == 1'b1)
        detected_reg = 1'b1;
end

// Sequential logic with clock gating
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        current_state <= IDLE;
        sequence_detected <= 1'b0;
    end
    else if (clk_enable) begin
        current_state <= next_state;
        sequence_detected <= detected_reg;
    end
end

endmodule