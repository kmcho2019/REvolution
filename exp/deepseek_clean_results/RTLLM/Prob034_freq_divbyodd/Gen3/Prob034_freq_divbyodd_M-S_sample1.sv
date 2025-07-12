module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    localparam HALF_DIV = (NUM_DIV - 1) / 2;
    reg [$clog2(NUM_DIV):0] cnt;

    always @(posedge clk or negedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end
        else begin
            cnt <= (cnt == NUM_DIV - 1) ? 0 : cnt + 1;
            if (cnt == HALF_DIV || cnt == NUM_DIV - 1)
                clk_div <= ~clk_div;
        end
    end

endmodule