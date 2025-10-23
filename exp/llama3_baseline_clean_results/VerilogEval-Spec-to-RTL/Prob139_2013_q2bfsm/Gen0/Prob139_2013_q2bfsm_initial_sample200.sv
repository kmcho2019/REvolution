module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

// Define the states of the FSM
enum logic [2:0] {
    A, // Initial state
    B, // State after reset is de-asserted
    C, // Monitor x input for sequence 1, 0, 1
    D, // Set output g to 1 and monitor y input
    E, // Output g permanently set to 1
    F  // Output g permanently set to 0
} state, next_state;

// Initialize the state
initial state = A;

// Sequential logic
always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end else begin
        state <= next_state;
        case (state)
            B: f <= 1;
            default: f <= 0;
        endcase
        case (state)
            D, E: g <= 1;
            default: g <= 0;
        endcase
    end
end

// Combinational logic
always_comb begin
    case (state)
        A: if (resetn) next_state = B;
            else next_state = A;
        B: next_state = C;
        C: if (x == 1) next_state = C1;
            else next_state = C;
        C1: if (x == 0) next_state = C2;
            else next_state = C;
        C2: if (x == 1) next_state = D;
            else next_state = C;
        D: if (y == 1 || g_y_counter == 2'b10) next_state = E;
            else if (g_y_counter == 2'b11) next_state = F;
            else next_state = D;
        E, F: next_state = state;
        default: next_state = A;
    endcase
end

// Counter for monitoring y input
logic [1:0] g_y_counter;
always_ff @(posedge clk) begin
    if (resetn && state == D) begin
        if (y == 1) g_y_counter <= 0;
        else g_y_counter <= g_y_counter + 1;
    end else begin
        g_y_counter <= 0;
    end
end

// Intermediate state for monitoring x input
logic C1, C2;
always_comb begin
    C1 = (state == C1);
    C2 = (state == C2);
end

endmodule