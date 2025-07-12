module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);

    // Parameter validation at elaboration time
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam CNT_WIDTH = $clog2(NUM_DIV);

    // Counters for posedge and negedge counting
    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    // Divided clock signals toggled on posedge and negedge
    reg clk_div_pos;
    reg clk_div_neg;

    // Counter and clk_div_pos toggling logic on posedge clock
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos    <= 0;
            clk_div_pos <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1) begin
                cnt_pos <= 0;
                clk_div_pos <= ~clk_div_pos;
            end else begin
                cnt_pos <= cnt_pos + 1;
            end
        end
    end

    // Counter and clk_div_neg toggling logic on negedge clock
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg    <= 0;
            clk_div_neg <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1) begin
                cnt_neg <= 0;
                clk_div_neg <= ~clk_div_neg;
            end else begin
                cnt_neg <= cnt_neg + 1;
            end
        end
    end

    // Final output is OR of posedge and negedge divided clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule