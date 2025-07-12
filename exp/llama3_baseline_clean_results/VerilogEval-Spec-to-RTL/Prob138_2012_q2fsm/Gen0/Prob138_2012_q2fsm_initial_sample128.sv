module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Enum for states
enum logic [2:0] {A = 3'b000, B, C, D, E, F} state, next_state;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        A: next_state = (w) ? B : A;
        B: next_state = (w) ? C : D;
        C: next_state = (w) ? E : D;
        D: next_state = (w) ? F : A;
        E: next_state = (w) ? E : D;
        F: next_state = (w) ? C : D;
        default: next_state = A;
    endcase
end

// Output z is determined by the current state
assign z = (state == E || state == F);

endmodule