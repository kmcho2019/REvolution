module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Division factors
    localparam DIV_50 = 2;
    localparam DIV_10_FROM_50 = 5;  // 50MHz->10MHz
    localparam DIV_1_FROM_10 = 10;  // 10MHz->1MHz

    // Counter terminal counts (pre-calculated)
    localparam CNT_50_TERM = DIV_50 - 1;
    localparam CNT_10_TERM = DIV_10_FROM_50 - 1;
    localparam CNT_1_TERM = DIV_1_FROM_10 - 1;

    // Internal clocks
    reg clk_50_int = 0;
    reg clk_10_int = 0;
    reg clk_1_int = 0;

    // Counters
    reg [0:0] cnt_50 = 0;
    reg [2:0] cnt_10 = 0;
    reg [3:0] cnt_1 = 0;

    // 50MHz clock (divide by 2)
    always @(posedge CLK_in) begin
        if (RST) begin
            clk_50_int <= 0;
            cnt_50 <= 0;
        end else begin
            if (cnt_50 == CNT_50_TERM) begin
                clk_50_int <= ~clk_50_int;
                cnt_50 <= 0;
            end else begin
                cnt_50 <= cnt_50 + 1;
            end
        end
    end

    // 10MHz clock (divide by 5 from 50MHz)
    always @(posedge clk_50_int) begin
        if (RST) begin
            clk_10_int <= 0;
            cnt_10 <= 0;
        end else begin
            if (cnt_10 == CNT_10_TERM) begin
                clk_10_int <= ~clk_10_int;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end
        end
    end

    // 1MHz clock (divide by 10 from 10MHz)
    always @(posedge clk_10_int) begin
        if (RST) begin
            clk_1_int <= 0;
            cnt_1 <= 0;
        end else begin
            if (cnt_1 == CNT_1_TERM) begin
                clk_1_int <= ~clk_1_int;
                cnt_1 <= 0;
            end else begin
                cnt_1 <= cnt_1 + 1;
            end
        end
    end

    // Output assignments
    assign CLK_50 = clk_50_int;
    assign CLK_10 = clk_10_int;
    assign CLK_1 = clk_1_int;

endmodule