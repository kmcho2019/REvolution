module freq_divbyodd #(parameter NUM_DIV = 5) (
    input  wire clk,
    input  wire rst_n,
    output wire clk_div
);
    // Parameter check at elaboration time
    initial begin
        if (NUM_DIV < 3 || (NUM_DIV % 2) == 0) begin
            $error("NUM_DIV must be an odd number >= 3");
        end
    end

    localparam HALF_COUNT = (NUM_DIV - 1) >> 1;  // integer division by 2
    localparam CNT_WIDTH = $clog2(NUM_DIV);

    reg [CNT_WIDTH-1:0] cnt_pos;
    reg [CNT_WIDTH-1:0] cnt_neg;

    reg clk_div_pos;
    reg clk_div_neg;

    // Positive edge counter and toggle
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_pos <= 0;
            clk_div_pos <= 0;
        end else begin
            if (cnt_pos == NUM_DIV - 1) begin
                cnt_pos <= 0;
                clk_div_pos <= ~clk_div_pos;
            end else begin
                cnt_pos <= cnt_pos + 1;
                if (cnt_pos == HALF_COUNT) begin
                    clk_div_pos <= ~clk_div_pos;
                end
            end
        end
    end

    // Negative edge counter and toggle
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_neg <= 0;
            clk_div_neg <= 0;
        end else begin
            if (cnt_neg == NUM_DIV - 1) begin
                cnt_neg <= 0;
                clk_div_neg <= ~clk_div_neg;
            end else begin
                cnt_neg <= cnt_neg + 1;
                if (cnt_neg == HALF_COUNT) begin
                    clk_div_neg <= ~clk_div_neg;
                end
            end
        end
    end

    // Combine the two divided clocks
    assign clk_div = clk_div_pos | clk_div_neg;

endmodule