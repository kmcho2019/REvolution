module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimal state encoding for minimal transitions
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state, next_state;
    wire clk_gated;
    reg clk_enable;

    // Clock gating for state A when w=0
    always @(*) begin
        clk_enable = ~(current_state == A && ~w);
    end

    assign clk_gated = clk & clk_enable;

    // State transition logic using case statement
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // Robust default case
        endcase
    end

    // Combined state storage and reset with gated clock
    always @(posedge clk_gated or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            z <= next_state[2]; // Registered output
        end
    end

endmodule