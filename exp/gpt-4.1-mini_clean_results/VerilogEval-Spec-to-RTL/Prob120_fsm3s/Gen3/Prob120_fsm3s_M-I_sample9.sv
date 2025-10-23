module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// One-hot state encoding (4 states)
localparam A = 4'b0001;
localparam B = 4'b0010;
localparam C = 4'b0100;
localparam D = 4'b1000;

reg [3:0] state, next_state;

// Next-state logic (combinational)
always @(*) begin
    // Default next_state to zero for safe coding
    next_state = 4'b0000;
    case (1'b1)
        state[A]: next_state = in ? B : A;
        state[B]: next_state = in ? B : C;
        state[C]: next_state = in ? D : A;
        state[D]: next_state = in ? B : C;
        default: next_state = A; // Safety fallback
    endcase
end

// State register with synchronous reset
always @(posedge clk) begin
    if (reset)
        state <= A;
    else
        state <= next_state;
end

// Output logic: 1 if in D, else 0
always @(*) begin
    out = (state == D) ? 1'b1 : 1'b0;
end

endmodule