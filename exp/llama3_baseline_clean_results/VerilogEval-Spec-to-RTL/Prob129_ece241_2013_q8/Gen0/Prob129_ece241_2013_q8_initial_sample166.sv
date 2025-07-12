module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

// Define the states
typedef enum logic [1:0] {
    IDLE    = 2'b00,
    FIRSTONE = 2'b01,
    SECONDONE = 2'b10
} state_t;

// Declare the current and next state
state_t current_state, next_state;

// Current state register
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Next state and output logic
always @* begin
    case (current_state)
        IDLE: begin
            if (x) begin
                next_state = FIRSTONE;
            end else begin
                next_state = IDLE;
            end
            z = 1'b0;
        end
        FIRSTONE: begin
            if (~x) begin
                next_state = SECONDONE;
            end else begin
                next_state = FIRSTONE;
            end
            z = 1'b0;
        end
        SECONDONE: begin
            if (x) begin
                next_state = FIRSTONE;  // Go back to FIRSTONE to allow for overlapping sequences
                z = 1'b1;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
            z = 1'b0;
        end
    endcase
end

endmodule