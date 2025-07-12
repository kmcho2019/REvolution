module freq_diveven (
    input wire clk,
    input wire rst_n,
    output reg clk_div
);

parameter NUM_DIV = 6;  // Must be even number

reg [3:0] cnt;  // Fixed 4-bit counter (supports up to divide by 16)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 1'b0;
    end else begin
        cnt <= (cnt == NUM_DIV - 1) ? 0 : cnt + 1;
        
        if (cnt == (NUM_DIV/2 - 1)) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule