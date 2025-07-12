module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg [0:0] state; // 0 for A, 1 for B
reg [0:0] next_state;

// Define the states
parameter B = 1'b1, A = 1'b0;

always @(*) begin
    case (state)
        B: if (!in) next_state = A;
             else next_state = B;
        A: if (!in) next_state = B;
             else next_state = A;
        default: next_state = B;
    endcase
end

always @(posedge clk) begin
    if (reset) state <= B;
    else state <= next_state;
end

// Output logic
always @(*) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule