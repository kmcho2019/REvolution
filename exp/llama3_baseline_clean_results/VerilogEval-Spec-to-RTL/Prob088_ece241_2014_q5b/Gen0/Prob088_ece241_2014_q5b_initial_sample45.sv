module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

// Define the states using one-hot encoding
reg [1:0] current_state;
reg [1:0] next_state;

// Define the initial state (A)
initial current_state = 2'b01;

// Define the state transitions
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A
        current_state <= 2'b01;
    end else begin
        // Update the current state
        current_state <= next_state;
    end
end

// Define the next state logic
always @(*) begin
    case (current_state)
        2'b01: // State A
            if (x == 0) begin
                next_state = 2'b01; // Stay in A
                z = 0;
            end else begin
                next_state = 2'b10; // Move to B
                z = 1;
            end
        2'b10: // State B
            if (x == 0) begin
                next_state = 2'b10; // Stay in B
                z = 1;
            end else begin
                next_state = 2'b10; // Stay in B
                z = 0;
            end
        default: // Invalid state
            next_state = 2'b01; // Reset to A
            z = 0;
    endcase
end

endmodule