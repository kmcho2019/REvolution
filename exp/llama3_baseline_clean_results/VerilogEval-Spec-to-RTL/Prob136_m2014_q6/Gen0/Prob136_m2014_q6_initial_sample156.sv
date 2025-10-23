module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

always @(*) begin
    // Determine the next state
    case (state)
        A: next_state = (w == 1'b1) ? A : B;
        B: next_state = (w == 1'b1) ? D : C;
        C: next_state = (w == 1'b1) ? D : E;
        D: next_state = (w == 1'b1) ? A : F;
        E: next_state = (w == 1'b1) ? D : E;
        F: next_state = (w == 1'b1) ? D : C;
        default: next_state = A;
    endcase
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        state <= A;
        z <= 1'b0;
    end else begin
        state <= next_state;
        // Determine the output z based on the state
        case (state)
            A: z <= 1'b0;
            B: z <= 1'b0;
            C: z <= 1'b0;
            D: z <= 1'b0;
            E: z <= 1'b1;
            F: z <= 1'b1;
            default: z <= 1'b0;
        endcase
    end
end

endmodule