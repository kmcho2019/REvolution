module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Validate parameter (must be odd and >=3)
    initial begin
        if (NUM_DIV < 3 || NUM_DIV[0] == 0) begin
            $error("NUM_DIV must be odd and >=3");
            $finish;
        end
    end

    // Calculate required counter width and toggle points
    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam HALF_POINT = (NUM_DIV-1)/2;

    reg [CNT_WIDTH-1:0] cnt;
    reg main_toggle, delayed_toggle;
    reg clk_div_reg;

    // Single counter for both edges
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            main_toggle <= 1'b0;
            delayed_toggle <= 1'b0;
        end else begin
            if (cnt == NUM_DIV-1) begin
                cnt <= 0;
                main_toggle <= ~main_toggle;
            end else begin
                cnt <= cnt + 1;
            end

            // Generate delayed toggle for phase alignment
            if (cnt == HALF_POINT) begin
                delayed_toggle <= 1'b1;
            end else begin
                delayed_toggle <= 1'b0;
            end
        end
    end

    // T-flipflop implementation for final clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div_reg <= 1'b0;
        end else begin
            if (main_toggle || delayed_toggle) begin
                clk_div_reg <= ~clk_div_reg;
            end
        end
    end

    assign clk_div = clk_div_reg;

endmodule