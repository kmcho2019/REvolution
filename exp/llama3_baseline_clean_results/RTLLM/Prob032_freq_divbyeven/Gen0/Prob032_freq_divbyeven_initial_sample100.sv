module freq_diveven(
    input  clk,      // Input clock signal
    input  rst_n,    // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

parameter NUM_DIV = 10;  // Division factor, must be an even number

reg [3:0] cnt;  // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // On reset, initialize counter and divided clock output to zero
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        // If counter is less than half of NUM_DIV - 1, increment counter
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            // When counter reaches the limit, reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule