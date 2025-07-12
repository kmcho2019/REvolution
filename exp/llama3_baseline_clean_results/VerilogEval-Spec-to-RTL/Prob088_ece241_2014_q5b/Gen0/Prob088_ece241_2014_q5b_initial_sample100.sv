module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// One-hot encoding for states
parameter A = 2'b10;
parameter B = 2'b01;

// Next state logic
always @(state, x) begin
    case (state)
        A: next_state = (x == 1'b0) ? A : B;
        B: next_state = B;
        default: next_state = A; // Default to state A
    endcase
end

// Output logic
assign z = (state == B) || (state == A && x == 1'b1);

// State register with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule