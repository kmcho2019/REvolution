module freq_divbyodd #(
    parameter NUM_DIV = 5
) (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

    reg [31:0] cnt;
    localparam HALF = (NUM_DIV - 1) / 2;

    always @(clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            clk_div <= 0;
        end else begin
            cnt <= cnt + 1;
            if (cnt == HALF) begin
                clk_div <= 1;
            end else if (cnt == NUM_DIV - 1) begin
                clk_div <= 0;
                cnt <= 0;
            end
        end
    end

endmodule