module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit state register
reg next_state;

// State definitions
parameter B = 1'b1;
parameter A = 1'b0;

// Output logic
always @(*) begin
    if (state == B) begin
        out = 1'b1;
    end else if (state == A) begin
        out = 1'b0;
    end else begin
        out = 1'b0; // default output
    end
end

// Next state logic
always @(*) begin
    case({state, in})
        {B, 1'b0}: next_state = A;
        {B, 1'b1}: next_state = B;
        {A, 1'b0}: next_state = B;
        {A, 1'b1}: next_state = A;
        default: next_state = B; // default next state
    endcase
end

// State register
always @(posedge clk) begin
    if (reset) begin
        state <= B; // synchronous reset
    end else begin
        state <= next_state;
    end
end

endmodule