module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output wire clk_div
);

    // Check if NUM_DIV is odd
    initial begin
        if (NUM_DIV % 2 == 0) begin
            $error("NUM_DIV must be an odd number");
            $finish;
        end
    end

    localparam HALF_DIV = (NUM_DIV - 1) / 2;
    reg [31:0] cnt1, cnt2;
    reg clk_div1, clk_div2;

    // Positive edge counter and clock divider
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt1 <= 0;
            clk_div1 <= 0;
        end else begin
            if (cnt1 == NUM_DIV - 1) begin
                cnt1 <= 0;
                clk_div1 <= ~clk_div1;
            end else begin
                cnt1 <= cnt1 + 1;
                if (cnt1 == HALF_DIV - 1)
                    clk_div1 <= ~clk_div1;
            end
        end
    end

    // Negative edge counter and clock divider
    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt2 <= 0;
            clk_div2 <= 0;
        end else begin
            if (cnt2 == NUM_DIV - 1) begin
                cnt2 <= 0;
                clk_div2 <= ~clk_div2;
            end else begin
                cnt2 <= cnt2 + 1;
                if (cnt2 == HALF_DIV - 1)
                    clk_div2 <= ~clk_div2;
            end
        end
    end

    // Combine both clock dividers
    assign clk_div = clk_div1 | clk_div2;

endmodule