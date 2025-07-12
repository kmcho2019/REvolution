module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define the states of the FSM
typedef enum logic [1:0] {
    IDLE    = 2'b00,
    STATE1  = 2'b01,
    STATE2  = 2'b10
} state_t;

state_t current_state, next_state;

// FSM logic
always_ff @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

always_comb begin
    case (current_state)
        IDLE: begin
            if (x) begin
                next_state = STATE1;
            end else begin
                next_state = IDLE;
            end
        end
        STATE1: begin
            if (~x) begin
                next_state = STATE2;
            end else begin
                next_state = STATE1;
            end
        end
        STATE2: begin
            if (x) begin
                next_state = STATE1;
            end else begin
                next_state = STATE1; // Go back to STATE1 to recognize overlapping sequences
            end
        end
        default: next_state = IDLE;
    endcase
end

// Output logic
always_comb begin
    case (current_state)
        IDLE: z = 1'b0;
        STATE1: z = 1'b0;
        STATE2: z = x; // Assert z when x is 1 in STATE2
        default: z = 1'b0;
    endcase
end

endmodule