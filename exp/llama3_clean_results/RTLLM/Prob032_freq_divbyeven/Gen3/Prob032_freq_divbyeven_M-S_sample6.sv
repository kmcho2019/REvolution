module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

parameter NUM_DIV = 8; // Must be an even number

reg [3:0] cnt; // Counter width sufficient for common division factors

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        cnt <= 0;
        clk_div <= !clk_div;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule