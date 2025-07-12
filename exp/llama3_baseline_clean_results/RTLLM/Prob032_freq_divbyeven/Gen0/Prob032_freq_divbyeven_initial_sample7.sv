module freq_diveven #(
    parameter NUM_DIV = 10  // Division factor, must be an even number
) (
    input  wire        clk,    // Input clock signal
    input  wire        rst_n,  // Active-low reset signal
    output reg         clk_div // Divided clock output signal
);

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'b0;
        clk_div <= 1'b0;
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1'b1;
    end else begin
        cnt <= 4'b0;
        clk_div <= ~clk_div;
    end
end

endmodule