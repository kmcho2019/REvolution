module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Named state encoding (3 bits for 6 states)
    parameter [2:0] A = 3'b000,
                   B = 3'b001,
                   C = 3'b010,
                   D = 3'b011,
                   E = 3'b100,
                   F = 3'b101;

    reg [2:0] current_state;

    // State transitions (case statement for better synthesis)
    always @(posedge clk) begin
        if (reset) begin
            current_state <= A;
        end else begin
            case (current_state)
                A: current_state <= w ? A : B;
                B: current_state <= w ? D : C;
                C: current_state <= w ? D : E;
                D: current_state <= w ? A : F;
                E: current_state <= w ? D : E;
                F: current_state <= w ? D : C;
                default: current_state <= A;
            endcase
        end
    end

    // Optimized output logic (E and F both have MSB set)
    assign z = current_state[2];

endmodule