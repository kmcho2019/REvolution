module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
enum logic [3:0] {
    A = 4'd0,
    B = 4'd1,
    C = 4'd2,
    D = 4'd3,
    E = 4'd4,
    F = 4'd5
} current_state, next_state;

// Output function based on current state
always_comb begin
    case (current_state)
        A, B, C, D: z = 1'b0;
        E, F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

// Next state logic
always_comb begin
    case (current_state)
        A: next_state = (w) ? A : B;
        B: next_state = (w) ? D : C;
        C: next_state = (w) ? D : E;
        D: next_state = (w) ? A : F;
        E: next_state = (w) ? D : E;
        F: next_state = (w) ? D : C;
        default: next_state = A;
    endcase
end

// State update on positive edge of clock
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

endmodule