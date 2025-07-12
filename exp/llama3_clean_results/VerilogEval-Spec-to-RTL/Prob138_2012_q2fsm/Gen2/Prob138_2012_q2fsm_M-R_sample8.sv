module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states as an enum
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// State flip-flops and next state logic
always_ff @ (posedge clk) begin
    if (reset) begin
        state <= A; // Reset to state A
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always_comb begin
    case (state)
        A: next_state = w? B : A;
        B: next_state = w? C : D;
        C: next_state = w? E : D;
        D: next_state = w? F : A;
        E: next_state = w? E : D;
        F: next_state = w? C : D;
        default: next_state = A; // Default to state A
    endcase
    
    // Output z logic
    z = (state == E) || (state == F);
end

endmodule