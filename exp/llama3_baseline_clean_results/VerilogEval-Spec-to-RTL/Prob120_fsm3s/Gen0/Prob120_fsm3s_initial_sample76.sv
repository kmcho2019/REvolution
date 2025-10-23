module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
typedef enum logic [1:0] {
    A,
    B,
    C,
    D
} state_t;

// Define the current state
reg state_t current_state;

// Combinational logic to determine the next state
always @(*) begin
    case (current_state)
        A: current_state = (in == 1'b0)? A : B;
        B: current_state = (in == 1'b0)? C : B;
        C: current_state = (in == 1'b0)? A : D;
        D: current_state = (in == 1'b0)? C : B;
    endcase
end

// Sequential logic to update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        // Use the state transition logic to update the state
        state_t next_state;
        case (current_state)
            A: next_state = (in == 1'b0)? A : B;
            B: next_state = (in == 1'b0)? C : B;
            C: next_state = (in == 1'b0)? A : D;
            D: next_state = (in == 1'b0)? C : B;
        endcase
        current_state <= next_state;
    end
end

// Output logic
always @(*) begin
    case (current_state)
        A: out = 1'b0;
        B: out = 1'b0;
        C: out = 1'b0;
        D: out = 1'b1;
    endcase
end

endmodule