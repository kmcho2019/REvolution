module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// Define the states
typedef enum logic [0:0] {
    A,
    B
} state_t;

// Register to hold the current state
state_t state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state B
        state <= B;
    end else begin
        // Handle state transitions based on current state and input
        case (state)
            A: begin
                if (in) begin
                    state <= A; // Stay in A if input is 1
                end else begin
                    state <= B; // Move to B if input is 0
                end
            end
            B: begin
                if (in) begin
                    state <= B; // Stay in B if input is 1
                end else begin
                    state <= A; // Move to A if input is 0
                end
            end
        endcase
    end
end

always @(state) begin
    // Determine output based on current state
    case (state)
        A: out <= 0;
        B: out <= 1;
    endcase
end

endmodule