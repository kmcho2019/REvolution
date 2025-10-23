module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
) (
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output reg  clk_div   // Divided clock output signal
);

reg [$clog2(NUM_DIV / 2):0] cnt_high;  // High counter width based on half of NUM_DIV
reg [$clog2(NUM_DIV):0] cnt_low;     // Low counter width based on NUM_DIV

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_high <= 0;
        cnt_low <= 0;
        clk_div <= 0;
    end else begin
        if (cnt_high == (NUM_DIV / 2) - 1) begin
            cnt_high <= 0;
            cnt_low <= cnt_low + 1;
            if (cnt_low == NUM_DIV - 1) begin
                cnt_low <= 0;
                clk_div <= ~clk_div;
            end
        end else begin
            cnt_high <= cnt_high + 1;
        end
    end
end

endmodule