module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized 2-bit state encoding with z output as combinational function
    // States with z=1: E(3), F(2) - these have state[1] set (except D)
    localparam [1:0] A = 2'b00,
                     B = 2'b01,
                     C = 2'b10,
                     D = 2'b11,
                     E = 2'b11,
                     F = 2'b10;

    reg [1:0] current_state, next_state;
    wire clk_gated;

    // Clock gating for state A when w=0
    assign clk_gated = clk & (~(current_state == A & ~w) | reset);

    // State transition logic - optimized combinational path
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
        endcase
    end

    // State register with synchronous reset and clock gating
    always @(posedge clk_gated) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Output z is high for states E and F (state[1] is set for both)
    assign z = (current_state == E) | (current_state == F);

endmodule