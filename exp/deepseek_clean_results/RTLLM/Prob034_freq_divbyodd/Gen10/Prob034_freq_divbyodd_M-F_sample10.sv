module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam MID_POINT = (NUM_DIV-1)/2;
    
    reg [CNT_WIDTH-1:0] cnt_p, cnt_n;
    reg clk_p, clk_n;

    // Positive edge counter and clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_p <= 0;
            clk_p <= 0;
        end
        else begin
            cnt_p <= (cnt_p == NUM_DIV-1) ? 0 : cnt_p + 1;
            if (cnt_p == MID_POINT)
                clk_p <= ~clk_p;
        end
    end

    // Negative edge counter and clock generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt_n <= 0;
            clk_n <= 0;
        end
        else begin
            cnt_n <= (cnt_n == NUM_DIV-1) ? 0 : cnt_n + 1;
            if (cnt_n == MID_POINT)
                clk_n <= ~clk_n;
        end
    end

    // Combine both edge contributions
    assign clk_div = clk_p | clk_n;

endmodule