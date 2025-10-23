module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

// Define the states using one-hot encoding
parameter A = 2'b01;
parameter B = 2'b10;

// Create a state register
reg [1:0] state;
reg [1:0] next_state;

// Determine the next state based on the current state and input
always @(*) begin
    case (state)
        A: begin
            if (x == 1'b0) next_state = A;
            else next_state = B;
        end
        B: begin
            next_state = B; // Self loop for B
        end
        default: next_state = A; // Default to A for invalid states
    endcase
end

// Determine the output (z) based on the current state and input
always @(*) begin
    case (state)
        A: z = x;
        B: z = ~x;
        default: z = 1'b0; // Default to 0 for invalid states
    endcase
end

// Update the state register on the positive edge of the clock
always @(posedge clk or posedge areset) begin
    if (areset) state <= A;
    else state <= next_state;
end

endmodule