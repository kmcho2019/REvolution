// Refactored frequency divider module
module freq_diveven (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output wire clk_div  // Divided clock output signal
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt;
reg clk_div_int;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        clk_div_int <= 1'b0;
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1;
    end else begin
        cnt <= 4'd0;
        clk_div_int <= ~clk_div_int;
    end
end

assign clk_div = clk_div_int;

endmodule