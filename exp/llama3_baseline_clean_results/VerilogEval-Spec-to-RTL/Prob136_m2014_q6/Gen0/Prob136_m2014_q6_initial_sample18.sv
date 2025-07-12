module TopModule(
    input        clk,
    input        reset,
    input        w,
    output logic z
);

// Define states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Combinational logic to determine next state
always_comb begin
    case (state)
        A: next_state = (w == 1'b0)? B : A;
        B: next_state = (w == 1'b0)? C : D;
        C: next_state = (w == 1'b0)? E : D;
        D: next_state = (w == 1'b0)? F : A;
        E: next_state = (w == 1'b0)? E : D;
        F: next_state = (w == 1'b0)? C : D;
        default: next_state = A;
    endcase
end

// Sequential logic to update current state
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
        z <= 1'b0;
    end else begin
        state <= next_state;
        // Determine output z based on current state
        case (state)
            E: z <= 1'b1;
            F: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
end

endmodule