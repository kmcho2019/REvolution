module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-cold shift register encoding:
    // A = 1110, B = 1101, C = 1011, D = 0111
    reg [3:0] state;

    // Output is simply the inverse of the LSB (for state D)
    assign out = ~state[0];

    always @(posedge clk) begin
        if (reset) begin
            // Initialize to state A (1110)
            state <= 4'b1110;
        end else begin
            case ({state, in})
                // State A transitions:
                4'b1110_0: state <= 4'b1110;  // A->A
                4'b1110_1: state <= 4'b1101;  // A->B
                // State B transitions:
                4'b1101_0: state <= 4'b1011;  // B->C
                4'b1101_1: state <= 4'b1101;  // B->B
                // State C transitions:
                4'b1011_0: state <= 4'b1110;  // C->A
                4'b1011_1: state <= 4'b0111;  // C->D
                // State D transitions:
                4'b0111_0: state <= 4'b1011;  // D->C
                4'b0111_1: state <= 4'b1101;  // D->B
                default: state <= 4'b1110;    // Fault recovery
            endcase
        end
    end

endmodule