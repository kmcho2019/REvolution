module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states as an enum
enum {B, A} state, next_state;

// Reset the state machine to state B when reset is high
always @(posedge clk) begin
    if (reset) begin
        state <= B;
    end else begin
        state <= next_state;
    end
end

// Determine the next state based on the current state and input 'in'
always @(*) begin
    case(state)
        B: begin
            if (in == 0) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        A: begin
            if (in == 0) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
    endcase
end

// Determine the output 'out' based on the current state
always @(*) begin
    case(state)
        B: out = 1;
        A: out = 0;
    endcase
end

endmodule