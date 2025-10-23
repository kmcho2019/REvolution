module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// One-hot encoding for states
parameter A = 2'b01;
parameter B = 2'b10;

// Output logic
always @(*)
begin
    case (current_state)
        A: z = ~x;
        B: z = x;
        default: z = 1'bx; // unknown state
    endcase
end

// Next state logic
always @(*)
begin
    case (current_state)
        A: next_state = (x == 1'b0) ? A : B;
        B: next_state = B;
        default: next_state = A; // default to state A
    endcase
end

// Sequential logic
always @(posedge clk or posedge areset)
begin
    if (areset)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule