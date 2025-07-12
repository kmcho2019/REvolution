module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active-low reset
    output reg clk_div       // Divided clock output
);

parameter NUM_DIV = 4;       // Default division by 4 (must be even)

reg [3:0] cnt;               // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (cnt == (NUM_DIV/2 - 1)) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule