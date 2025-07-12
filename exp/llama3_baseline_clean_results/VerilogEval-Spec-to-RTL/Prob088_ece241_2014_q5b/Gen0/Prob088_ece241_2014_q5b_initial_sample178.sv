module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

// Define states using one-hot encoding
parameter A = 2'b10;
parameter B = 2'b01;

// Current state and next state variables
reg [1:0] curr_state;
reg [1:0] next_state;

// Output logic
always @(curr_state, x) begin
    case (curr_state)
        A: z = x;
        B: z = ~x;
        default: z = 1'b0; // Default output
    endcase
end

// Sequential logic with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        curr_state <= A;
    end else begin
        curr_state <= next_state;
    end
end

// Next state logic
always @(curr_state, x) begin
    case (curr_state)
        A: if (x) next_state = B; else next_state = A;
        B: next_state = B; // Self-loop regardless of x
        default: next_state = A; // Default next state
    endcase
end

endmodule