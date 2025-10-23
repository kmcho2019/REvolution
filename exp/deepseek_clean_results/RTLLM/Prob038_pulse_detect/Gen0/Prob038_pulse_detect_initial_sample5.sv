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

// State register
state_t state, next_state;

// Sequential state transition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 1'b0;
    end
    else begin
        state <= next_state;
        // Output is high only when we complete the pulse (transition from GOT_1 to IDLE)
        data_out <= (state == GOT_1 && data_in == 1'b0) ? 1'b1 : 1'b0;
    end
end

// Combinational next state logic
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
                next_state = GOT_0;  // Stay in GOT_0 if we get consecutive 0s
        end
        GOT_1: begin
            if (data_in == 1'b0)
                next_state = IDLE;
            else
                next_state = GOT_1;  // Stay in GOT_1 if we get consecutive 1s
        end
        default: next_state = IDLE;
    endcase
end

endmodule