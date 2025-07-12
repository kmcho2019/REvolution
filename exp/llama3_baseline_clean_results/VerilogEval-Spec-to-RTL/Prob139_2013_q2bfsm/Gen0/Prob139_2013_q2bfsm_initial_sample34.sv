module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states
enum logic [2:0] {
    A = 3'b000, // Reset state
    B = 3'b001, // Set f to 1
    C = 3'b010, // Monitor x for 1
    D = 3'b011, // Monitor x for 0
    E = 3'b100, // Monitor x for 1 again
    F = 3'b101, // Set g to 1, monitor y
    G = 3'b110, // Permanent g = 1
    H = 3'b111  // Permanent g = 0
} state, nextState;

// Internal registers for x sequence detection
logic x_prev1, x_prev2;
logic y_prev1;

always_ff @(posedge clk) begin
    if (!resetn) begin
        state <= A;
        x_prev1 <= 0;
        x_prev2 <= 0;
        y_prev1 <= 0;
        f <= 0;
        g <= 0;
    end else begin
        state <= nextState;
        x_prev1 <= x;
        x_prev2 <= x_prev1;
        y_prev1 <= y;
        case (state)
            B: f <= 1;
            default: f <= 0;
        endcase
        case (state)
            F, G: g <= 1;
            default: g <= 0;
        endcase
    end
end

always_comb begin
    case (state)
        A: if (!resetn) nextState = A;
           else nextState = B;
        B: nextState = C;
        C: if (x) nextState = D;
           else nextState = C;
        D: if (!x) nextState = E;
           else nextState = C;
        E: if (x) nextState = F;
           else nextState = C;
        F: if (y || y_prev1) nextState = G;
           else if (!y && !y_prev1) nextState = H;
           else nextState = F;
        G, H: nextState = state;
        default: nextState = A;
    endcase
end

endmodule