module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

// Define states
typedef enum logic [1:0] {
    IDLE,
    GOT_0,
    GOT_1
} state_t;

reg [1:0] state, next_state;

// State transition logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end else begin
        state <= next_state;
        
        // Output logic: pulse only when we complete the sequence
        data_out <= (state == GOT_1) && (data_in == 1'b0);
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b0)
                next_state = GOT_0;
            else
                next_state = IDLE;
        end
        GOT_0: begin
            if (data_in == 1'b1)
                next_state = GOT_1;
            else
                next_state = GOT_0;  // Stay here if we get consecutive 0s
        end
        GOT_1: begin
            if (data_in == 1'b0)
                next_state = IDLE;   // Sequence complete, return to IDLE
            else
                next_state = IDLE;   // If we get 1->1, reset (not part of our sequence)
        end
        default: next_state = IDLE;
    endcase
end

endmodule