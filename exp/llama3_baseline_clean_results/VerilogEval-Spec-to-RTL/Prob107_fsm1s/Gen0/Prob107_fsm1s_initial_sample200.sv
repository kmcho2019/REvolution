module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter B = 1'b0, A = 1'b1;

// Internal state signal
reg current_state;
reg next_state;

// Output logic
always @(current_state)
begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
    endcase
end

// Next state logic
always @(current_state, in)
begin
    case(current_state)
        B: if (!in) next_state = A; else next_state = B;
        A: if (!in) next_state = B; else next_state = A;
    endcase
end

// State register with synchronous reset
always @(posedge clk)
begin
    if (reset) current_state <= B;
    else current_state <= next_state;
end

endmodule