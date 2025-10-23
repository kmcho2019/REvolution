module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// State encoding
localparam A = 2'd0,
           B = 2'd1,
           C = 2'd2,
           D = 2'd3;

reg [1:0] state, next_state;

// Asynchronous reset and state register
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= A;
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case(state)
        A: next_state = (in == 0) ? A : B;
        B: next_state = (in == 0) ? C : B;
        C: next_state = (in == 0) ? A : D;
        D: next_state = (in == 0) ? C : B;
        default: next_state = A;
    endcase
end

// Output logic (Moore)
always @(*) begin
    case(state)
        D: out = 1'b1;
        default: out = 1'b0;
    endcase
end

endmodule