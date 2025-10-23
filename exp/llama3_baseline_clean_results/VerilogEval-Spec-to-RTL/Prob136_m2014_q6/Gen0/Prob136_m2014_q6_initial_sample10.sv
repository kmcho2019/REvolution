module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b011,
    D = 3'b100,
    E = 3'b101,
    F = 3'b110
} state, next_state;

// State register
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        A: next_state = (w == 1'b0)? B : A;
        B: next_state = (w == 1'b0)? C : D;
        C: next_state = (w == 1'b0)? E : D;
        D: next_state = (w == 1'b0)? F : A;
        E: next_state = (w == 1'b0)? E : D;
        F: next_state = (w == 1'b0)? C : D;
        default: next_state = A; // Default to state A
    endcase
end

// Output logic
always_comb begin
    case (state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0; // Default to 0
    endcase
end

endmodule