module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

// Define the states as enumerations
typedef enum logic [1:0] {
    A = 2'b00,
    B = 2'b01,
    C = 2'b10,
    D = 2'b11
} state_t;

// Current and next state
state_t current_state, next_state;

// Output logic based on the current state
always_comb begin
    case (current_state)
        A, B, C: out = 1'b0;
        D: out = 1'b1;
        default: out = 1'bx; // Invalid state, set output to unknown
    endcase
end

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset to state A
        current_state <= A;
    end else begin
        // Determine next state based on current state and input
        case (current_state)
            A: begin
                if (!in) begin
                    next_state <= A;
                end else begin
                    next_state <= B;
                end
            end
            B: begin
                if (!in) begin
                    next_state <= C;
                end else begin
                    next_state <= B;
                end
            end
            C: begin
                if (!in) begin
                    next_state <= A;
                end else begin
                    next_state <= D;
                end
            end
            D: begin
                if (!in) begin
                    next_state <= C;
                end else begin
                    next_state <= B;
                end
            end
            default: next_state <= A; // Invalid state, transition to A
        endcase
        current_state <= next_state;
    end
end

endmodule