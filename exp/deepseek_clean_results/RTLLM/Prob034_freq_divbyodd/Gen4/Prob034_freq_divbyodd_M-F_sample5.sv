module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    localparam CNT_WIDTH = $clog2(NUM_DIV);
    localparam THRESHOLD = NUM_DIV / 2;  // Integer division for odd NUM_DIV
    
    reg [CNT_WIDTH-1:0] cnt1, cnt2;
    reg clk_div1, clk_div2;

    // Positive edge counter and divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end
        else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end
            else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == THRESHOLD - 1)
                    clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge counter and divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end
        else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end
            else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == THRESHOLD - 1)
                    clk_div2 <= ~clk_div2;
            end
        end
    end

    // Combine both divided clocks
    assign clk_div = clk_div1 | clk_div2;

endmodule