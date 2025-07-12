module TopModule (
    input clk,
    input a,
    output reg q
);

// Define states
typedef enum logic {STATE_0, STATE_1} state_t;
state_t current_state, next_state;

// State transition logic
always @(posedge clk) begin
    current_state <= next_state;
end

// Next state and output logic
always @(*) begin
    case (current_state)
        STATE_0: begin
            q = 1'b1;
            next_state = a ? STATE_1 : STATE_0;
        end
        STATE_1: begin
            q = 1'b0;
            next_state = a ? STATE_1 : STATE_0;
        end
        default: begin
            q = 1'b0;
            next_state = STATE_0;
        end
    endcase
end

// Initial state
initial begin
    current_state = STATE_0;
end

endmodule