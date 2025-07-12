module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);

// Define the states of the FSM
typedef enum logic [1:0] {
    IDLE,
    GOT_11,
    GOT_110,
    FOUND
} state_t;

// Initialize the current state and output
state_t current_state;
reg start_shifting_reg;

// FSM logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
        start_shifting_reg <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data) begin
                    current_state <= GOT_11;
                end
            end
            GOT_11: begin
                if (data) begin
                    current_state <= GOT_110;
                end else begin
                    current_state <= IDLE;
                end
            end
            GOT_110: begin
                if (data) begin
                    current_state <= IDLE;
                end else begin
                    current_state <= FOUND;
                end
            end
            FOUND: begin
                // Stay in FOUND state forever until reset
                start_shifting_reg <= 1;
            end
        endcase
    end
end

assign start_shifting = start_shifting_reg;

endmodule