module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} current_state, next_state;

// Combinational logic to determine next state
always_comb begin
    case(current_state)
        A: next_state = (w) ? A : B;
        B: next_state = (w) ? D : C;
        C: next_state = (w) ? D : E;
        D: next_state = (w) ? A : F;
        E: next_state = (w) ? D : E;
        F: next_state = (w) ? D : C;
        default: next_state = A; // default to A
    endcase
end

// Sequential logic to update current state
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Output logic
assign z = (current_state == E) || (current_state == F);

endmodule