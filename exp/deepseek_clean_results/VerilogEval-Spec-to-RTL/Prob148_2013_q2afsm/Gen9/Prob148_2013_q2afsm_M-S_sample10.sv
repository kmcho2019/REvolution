module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // One-hot state encoding: A=0001, B=0010, C=0100, D=1000
    reg [3:0] state;

    // State transitions and output generation
    always @(posedge clk) begin
        if (!resetn) begin
            state <= 4'b0001; // Reset to state A
        end else begin
            case (state)
                4'b0001: // State A
                    if (r[0]) state <= 4'b0010; // B
                    else if (r[1]) state <= 4'b0100; // C
                    else if (r[2]) state <= 4'b1000; // D
                4'b0010: // State B
                    if (!r[0]) state <= 4'b0001; // A
                4'b0100: // State C
                    if (!r[1]) state <= 4'b0001; // A
                // State D has no transitions (stays until reset per spec)
                default: state <= 4'b0001; // Default to A
            endcase
        end
    end

    // Outputs directly from state
    assign g[0] = (state == 4'b0010); // B
    assign g[1] = (state == 4'b0100); // C
    assign g[2] = (state == 4'b1000); // D

endmodule