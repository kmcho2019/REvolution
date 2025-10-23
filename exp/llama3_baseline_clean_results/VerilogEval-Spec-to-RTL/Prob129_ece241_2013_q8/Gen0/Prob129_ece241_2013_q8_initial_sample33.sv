module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// State definition
typedef enum logic [1:0] {
    IDLE = 2'b00,
    SEQ_1 = 2'b01,
    SEQ_10 = 2'b10
} state_t;

// Current state and next state
state_t current_state;
state_t next_state;

// Output
assign z = (current_state == SEQ_10 && x == 1'b1) ? 1'b1 : 1'b0;

// State register
always_ff @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state logic
always_comb begin
    case(current_state)
        IDLE: begin
            if (x == 1'b1) begin
                next_state = SEQ_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEQ_1: begin
            if (x == 1'b0) begin
                next_state = SEQ_10;
            end else begin
                next_state = SEQ_1;
            end
        end
        SEQ_10: begin
            if (x == 1'b1) begin
                next_state = SEQ_1;
            end else begin
                next_state = SEQ_10;
            end
        end
    endcase
end

endmodule