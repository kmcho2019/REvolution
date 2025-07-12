module freq_diveven #(
    parameter NUM_DIV = 10  // Must be an even number
)(
    input  wire        clk, 
    input  wire        rst_n, 
    output reg         clk_div
);

reg [3:0] cnt;  // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Active-low reset
        cnt <= 4'd0;   // Reset counter
        clk_div <= 1'b0;  // Reset divided clock output
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1;  // Increment counter
    end else begin
        cnt <= 4'd0;  // Reset counter when it reaches the limit
        clk_div <= ~clk_div;  // Toggle divided clock output
    end
end

endmodule