module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// State register
state_t state, next_state;

// Next state logic
always @(state, w) begin
    case (state)
        A: next_state = (w == 1'b1) ? B : A;
        B: next_state = (w == 1'b1) ? C : D;
        C: next_state = (w == 1'b1) ? E : D;
        D: next_state = (w == 1'b1) ? F : A;
        E: next_state = (w == 1'b1) ? E : D;
        F: next_state = (w == 1'b1) ? C : D;
        default: next_state = A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign z = (state == E || state == F) ? 1'b1 : 1'b0;

endmodule