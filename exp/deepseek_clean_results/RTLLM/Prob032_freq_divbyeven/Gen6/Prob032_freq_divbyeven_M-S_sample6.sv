module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6; // Default division factor (must be even)

// Validate parameter (synthesis-time check)
initial begin
    if (NUM_DIV % 2 != 0) begin
        $error("NUM_DIV must be an even number");
    end
end

localparam CNT_MAX = (NUM_DIV / 2) - 1;
reg [3:0] cnt; // 4-bit counter sufficient for division up to 32

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (cnt == CNT_MAX) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule