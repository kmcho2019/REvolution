module freq_diveven #(
    parameter NUM_DIV = 4  // Division factor, must be an even number
) (
    input  wire clk,      // Input clock signal
    input  wire rst_n,    // Active-low reset signal
    output reg  clk_div   // Divided clock output signal
);

reg [$clog2(NUM_DIV):0] cnt;  // Counter width based on NUM_DIV

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else if (cnt < (NUM_DIV / 2)) begin
        cnt <= cnt + 1;
    end else begin
        cnt <= 0;
        clk_div <= ~clk_div;
    end
end

endmodule