module TopModule (
    input clk,
    input reset,
    input w,
    output z
);

    // Maintain same optimized state encoding
    localparam [2:0] A = 3'b000,
                     B = 3'b001,
                     C = 3'b011,
                     D = 3'b010,
                     E = 3'b111,
                     F = 3'b110;

    reg [2:0] state;

    // Continuous assignments for each state's transition conditions
    wire to_A = (state == D && !w) || (state == A && !w) || reset;
    wire to_B = (state == A && w) || (state == D && w && reset);
    wire to_C = (state == B && w) || (state == F && w);
    wire to_D = (state == B && !w) || (state == C && !w) || 
                (state == E && !w) || (state == F && !w);
    wire to_E = (state == C && w) || (state == E && w);
    wire to_F = (state == D && w);

    // State register with direct transition logic
    always @(posedge clk) begin
        if (reset) state <= A;
        else begin
            case (1'b1)  // Parallel case pattern
                to_A: state <= A;
                to_B: state <= B;
                to_C: state <= C;
                to_D: state <= D;
                to_E: state <= E;
                to_F: state <= F;
                default: state <= state;
            endcase
        end
    end

    // Output remains simple bit check
    assign z = state[2];

endmodule