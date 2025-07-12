module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

// Define the one-hot encoding states
reg [1:0] current_state, next_state;
parameter STATE_A = 2'b01;
parameter STATE_B = 2'b10;

// Output logic
always @(current_state, x) begin
    case(current_state)
        STATE_A: z = x;
        STATE_B: z = ~x;
        default: z = 1'b0; // This line is to prevent a linter warning about z being undefined.
    endcase
end

// Next state logic
always @(current_state, x) begin
    case(current_state)
        STATE_A: if (x) next_state = STATE_B; else next_state = STATE_A;
        STATE_B: next_state = STATE_B; // Regardless of x, stay in B
        default: next_state = STATE_A; // Default to A if in an invalid state
    endcase
end

// Sequential logic (registers)
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= STATE_A;
    end else begin
        current_state <= next_state;
    end
end

endmodule