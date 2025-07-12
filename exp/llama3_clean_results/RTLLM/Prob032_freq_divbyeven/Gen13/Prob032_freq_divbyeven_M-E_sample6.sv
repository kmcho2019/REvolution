module freq_diveven #(
    parameter NUM_DIV = 8 // Must be an even number
) (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output reg  clk_div  // Divided clock output signal
);

reg [3:0] ring_cnt; // Ring counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        ring_cnt <= 4'b0;
        clk_div <= 1'b0;
    end else begin
        if (ring_cnt == (NUM_DIV - 1)) begin
            ring_cnt <= 4'b0;
            clk_div <= ~clk_div;
        end else begin
            ring_cnt <= ring_cnt + 1;
        end
    end
end

endmodule