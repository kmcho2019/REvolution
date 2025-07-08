module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_dly;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_dly <= 1'b0;
            rise  <= 1'b0;
            down  <= 1'b0;
        end else begin
            // Detect edges
            wire rising_edge  = (a_dly == 1'b0) && (a == 1'b1);
            wire falling_edge = (a_dly == 1'b1) && (a == 1'b0);

            a_dly <= a;

            // For rise output:
            // If rising edge detected now, set rise to 1
            // If another rising edge occurs, rise remains 1 (already set)
            // But the requirement says rise stays 1 until the corresponding edge appears again.
            // This means rise should be set to 1 on rising edge and remain 1 until next rising edge,
            // but since it is edge triggered, it just remains 1 after set.
            // Actually, requirement says: rise or down set to 1 on next clock when edge appears, then return to 0 until edge appears again.
            // So, rise should be set to 1 only for one cycle after rising edge, then 0 until next rising edge.
            // The difference is “rise or down will be set to 1 on the next clock when edge appears, and then return to 0 until the corresponding edge appears again.”
            // So rise and down are pulse signals lasting one clock cycle on the cycle after edge detection.

            // So here, rise and down should be pulse signals synchronized to clk and 1 cycle wide.

            rise <= rising_edge;
            down <= falling_edge;
        end
    end

endmodule