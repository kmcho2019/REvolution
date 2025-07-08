module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// State encoding
typedef enum reg [1:0] {
    A = 2'd0,
    B = 2'd1,
    C = 2'd2,
    D = 2'd3
} state_t;

reg [1:0] current_state, next_state;

// State transition logic
always @(*) begin
    case (current_state)
        A: next_state = (in == 1'b0) ? A : B;
        B: next_state = (in == 1'b0) ? C : B;
        C: next_state = (in == 1'b0) ? A : D;
        D: next_state = (in == 1'b0) ? C : B;
        default: next_state = A;
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if (reset)
        current_state <= A;
    else
        current_state <= next_state;
end

// Output logic (Moore FSM)
always @(*) begin
    case (current_state)
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule