module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states as an enumeration
enum logic [2:0] {A, B, C, D, E, F} state, next_state;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Combinational logic for next state and output
always_comb begin
    case (state)
        A: if (w) next_state = A; else next_state = B;
        B: if (w) next_state = D; else next_state = C;
        C: if (w) next_state = D; else next_state = E;
        D: if (w) next_state = A; else next_state = F;
        E: if (w) next_state = D; else next_state = E;
        F: if (w) next_state = D; else next_state = C;
    endcase
    
    // Determine output z based on current state
    case (state)
        A, B, C, D: z = 0;
        E, F: z = 1;
    endcase
end

endmodule