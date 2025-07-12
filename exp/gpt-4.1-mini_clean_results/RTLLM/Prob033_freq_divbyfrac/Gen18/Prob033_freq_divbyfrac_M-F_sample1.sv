module freq_divbyfrac (
    input  wire clk,
    input  wire rst_n,
    output reg  clk_div
);
    // Parameters for fractional division by 3.5 (7/2)
    // Total half-period count = 7 (MUL2_DIV_CLK)
    localparam integer MUL2_DIV_CLK = 7;

    // Counter for half cycles (counts 0..6)
    reg [2:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count   <= 3'd0;
            clk_div <= 1'b0;
        end else begin
            if (count == (MUL2_DIV_CLK - 1)) begin
                count <= 3'd0;
                clk_div <= ~clk_div;  // Toggle output clock at end of full period
            end else begin
                count <= count + 1'b1;
                // Toggle clk_div at half period point (unequal half periods)
                // For division by 3.5, toggle again at count = 3 (middle)
                if (count == 3)
                    clk_div <= ~clk_div;
            end
        end
    end
endmodule