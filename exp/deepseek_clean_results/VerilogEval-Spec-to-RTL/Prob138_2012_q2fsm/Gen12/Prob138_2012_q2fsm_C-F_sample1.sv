module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Optimized hybrid state encoding
    localparam [2:0] A = 3'b000,  // Gray-code like for A-D
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b110,  // One-hot like for E/F (output states)
                     F = 3'b111;

    reg [2:0] current_state, next_state;

    // Optimized state transition logic
    always @(*) begin
        case (current_state)
            A: next_state = w ? B : A;  // Ternary for most common transition
            B: begin
                if (w) next_state = C;
                else next_state = D;
            end
            C: begin
                if (w) next_state = E;
                else next_state = D;
            end
            D: next_state = w ? F : A;  // Ternary for critical return path
            E: begin
                if (w) next_state = E;
                else next_state = D;
            end
            F: begin
                if (w) next_state = C;
                else next_state = D;
            end
            default: next_state = A;  // Self-correcting for invalid states
        endcase
    end

    // State storage with synchronous reset
    always @(posedge clk) begin
        current_state <= reset ? A : next_state;
    end

    // Optimal output logic
    assign z = current_state[2];

endmodule