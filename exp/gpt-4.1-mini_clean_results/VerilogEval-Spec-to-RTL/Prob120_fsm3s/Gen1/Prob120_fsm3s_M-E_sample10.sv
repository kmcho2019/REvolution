module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// One-hot state encoding
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

reg [3:0] state, next_state;

// Next state combinational logic using one-hot encoding
always @(*) begin
    next_state = 4'b0000;
    case (1'b1)
        state[0]: // State A
            next_state = in ? B : A;
        state[1]: // State B
            next_state = in ? B : C;
        state[2]: // State C
            next_state = in ? D : A;
        state[3]: // State D
            next_state = in ? B : C;
        default:
            next_state = A;
    endcase
end

// State flip-flops with synchronous active-high reset
always @(posedge clk) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Output logic (Moore machine: output depends only on current state)
always @(*) begin
    out = state[3]; // Output is 1 only in state D
end

endmodule