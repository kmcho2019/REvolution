module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [1:0] current_state; // Using 2 bits for one-hot encoding
reg [1:0] next_state;

// Define states (for simplicity, we'll directly use binary values)
parameter A = 2'b01;
parameter B = 2'b10;

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= A; // Reset to state A
    end else begin
        current_state <= next_state;
    end
end

// Determine next state and output based on current state and input 'x'
always @(*) begin
    case (current_state)
        A: begin
            if (x == 0) begin
                next_state = A;
                z = 0;
            end else begin
                next_state = B;
                z = 1;
            end
        end
        B: begin
            next_state = B; // Remain in state B
            z = ~x; // Output is the inverse of 'x' when in state B
        end
        default: begin
            next_state = A; // Default back to state A
            z = 0;
        end
    endcase
end

endmodule