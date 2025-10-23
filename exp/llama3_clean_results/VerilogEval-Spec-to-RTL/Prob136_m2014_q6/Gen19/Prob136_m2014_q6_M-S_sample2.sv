module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using an enum for clarity
enum logic [2:0] {
    A = 3'b001,
    B = 3'b010,
    C = 3'b011,
    D = 3'b100,
    E = 3'b101,
    F = 3'b110
} state, next_state;

// Update the state and output on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        case (state)
            A: next_state = w ? A : B;
            B: next_state = w ? D : C;
            C: next_state = w ? D : E;
            D: next_state = w ? A : F;
            E: next_state = w ? D : E;
            F: next_state = w ? D : C;
            default: next_state = A;
        endcase
        state <= next_state;
        // Directly assign output z based on the current state
        z <= (state == E) || (state == F);
    end
end

endmodule