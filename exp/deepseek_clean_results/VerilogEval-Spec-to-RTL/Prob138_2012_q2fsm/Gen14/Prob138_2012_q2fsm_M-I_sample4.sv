module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Optimized state encoding with E and F adjacent
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b100,  // Changed from 110 to be adjacent to F
                     F = 3'b110;  // Changed from 100

    reg [2:0] current_state, next_state;

    // State transition logic with optimized case statement
    always @(*) begin
        // synthesis parallel_case
        case (current_state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;  // Flattened if-else
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A;    // Handle undefined states
        endcase
    end

    // State storage with clock gating opportunity
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
            z <= 1'b0;
        end
        else begin
            current_state <= next_state;
            // Registered output for better timing
            z <= next_state[2];  // Still works with new encoding
        end
    end

endmodule