module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimized state encoding with maximal Hamming distance for output states
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,
                     F = 3'b111;

    reg [2:0] current_state, next_state;
    wire gated_clk;

    // Clock gating for state A when w=0 (no transition)
    assign gated_clk = (current_state == A && !w) ? 1'b0 : clk;

    // State transition logic with synthesis attributes
    (* parallel_case, full_case *)
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;
        endcase
    end

    // State storage with synchronous reset
    always @(posedge gated_clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            // More reliable output assignment
            z <= (next_state == E) | (next_state == F);
        end
    end

    /* Alternative asynchronous reset version:
    always @(posedge gated_clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            z <= (next_state == E) | (next_state == F);
        end
    end
    */

endmodule