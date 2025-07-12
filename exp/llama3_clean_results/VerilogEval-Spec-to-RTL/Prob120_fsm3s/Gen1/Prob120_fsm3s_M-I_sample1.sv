module TopModule(
    input clk,
    input reset,
    input in,
    output reg out // Declare 'out' as reg
);

// Define the states
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current state
state_t current_state;

// Sequential logic and output logic combined
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
        out <= 1'b0; // Reset output to 0 when reset is high
    end else begin
        case (current_state)
            A: begin
                if (!in) current_state <= A;
                else current_state <= B;
                out <= 1'b0; // Output for states A, B, C
            end
            B: begin
                if (!in) current_state <= C;
                else current_state <= B;
                out <= 1'b0; // Output for states A, B, C
            end
            C: begin
                if (!in) current_state <= A;
                else current_state <= D;
                out <= 1'b0; // Output for states A, B, C
            end
            D: begin
                if (!in) current_state <= C;
                else current_state <= B;
                out <= 1'b1; // Output for state D
            end
            default: begin
                current_state <= A;
                out <= 1'b0;
            end
        endcase
    end
end

endmodule