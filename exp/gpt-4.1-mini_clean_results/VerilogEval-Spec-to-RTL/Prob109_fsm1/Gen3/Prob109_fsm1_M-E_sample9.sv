module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

// One-hot encoding for states
localparam A = 2'b01;
localparam B = 2'b10;

reg [1:0] state, next_state;

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= B;  // reset to state B
    else
        state <= next_state;
end

// Next state logic
always @(*) begin
    case (state)
        B: next_state = (in == 1'b0) ? A : B;
        A: next_state = (in == 1'b0) ? B : A;
        default: next_state = B;
    endcase
end

// Output logic for Moore machine: output = 1 if in B, 0 if in A
always @(*) begin
    if (state == B)
        out = 1'b1;
    else
        out = 1'b0;
end

endmodule