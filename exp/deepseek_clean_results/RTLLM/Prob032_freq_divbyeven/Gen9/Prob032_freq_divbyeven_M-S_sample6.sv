module freq_diveven (
    input wire clk,
    input wire rst_n,        // Active low synchronous reset
    output reg clk_div      // Divided clock output
);

parameter NUM_DIV = 4;      // Must be even number

reg [3:0] cnt;              // Fixed width counter (supports up to div-by-32)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end
    else begin
        if (cnt == (NUM_DIV/2)-1) begin
            cnt <= 0;
            clk_div <= ~clk_div;
        end
        else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule