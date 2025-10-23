module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam HIGH_CYCLES = (NUM_DIV + 1)/2;
    localparam LOW_CYCLES = (NUM_DIV - 1)/2;

    reg [CNT_WIDTH-1:0] pos_cnt;
    reg [CNT_WIDTH-1:0] neg_cnt;
    reg pos_toggle;
    reg neg_toggle;

    // Positive edge counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pos_cnt <= 0;
            pos_toggle <= 0;
        end else begin
            if (pos_cnt == HIGH_CYCLES-1) begin
                pos_toggle <= 1;
                pos_cnt <= 0;
            end else begin
                pos_toggle <= 0;
                pos_cnt <= pos_cnt + 1;
            end
        end
    end

    // Negative edge counter
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            neg_cnt <= 0;
            neg_toggle <= 0;
        end else begin
            if (neg_cnt == LOW_CYCLES-1) begin
                neg_toggle <= 1;
                neg_cnt <= 0;
            end else begin
                neg_toggle <= 0;
                neg_cnt <= neg_cnt + 1;
            end
        end
    end

    // Output generation with set/reset flip-flop
    reg div_out;
    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            div_out <= 0;
        end else begin
            case ({pos_toggle, neg_toggle})
                2'b10: div_out <= 1;  // Set on positive edge toggle
                2'b01: div_out <= 0;  // Reset on negative edge toggle
                default: div_out <= div_out;
            endcase
        end
    end

    assign clk_div = div_out;

endmodule