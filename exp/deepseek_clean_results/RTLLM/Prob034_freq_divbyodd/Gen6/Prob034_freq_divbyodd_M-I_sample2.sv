module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    reg [31:0] cnt1, cnt2;
    reg clk_div1, clk_div2;
    localparam HALF_CYCLE = (NUM_DIV - 1) / 2;

    // Positive edge counter and clock generation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= 0;
            end else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == HALF_CYCLE) begin
                    clk_div1 <= 1;
                end
            end
        end
    end

    // Negative edge counter and clock generation
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= 0;
            end else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == HALF_CYCLE) begin
                    clk_div2 <= 1;
                end
            end
        end
    end

    // Combine both clock signals
    assign clk_div = clk_div1 | clk_div2;

endmodule