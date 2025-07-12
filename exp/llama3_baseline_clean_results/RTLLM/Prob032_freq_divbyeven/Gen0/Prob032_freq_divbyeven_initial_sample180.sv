module freq_diveven #(
    parameter NUM_DIV = 10 // Even number for division factor, default is 10
)(
    input  clk,
    input  rst_n,
    output reg clk_div
);

reg [3:0] cnt; // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        cnt <= 4'd0; // Reset counter
        clk_div <= 1'b0; // Reset divided clock output
    end else if (cnt < (NUM_DIV / 2 - 1)) begin // Increment counter if not at limit
        cnt <= cnt + 1;
    end else begin // At limit, reset counter and toggle clk_div
        cnt <= 4'd0;
        clk_div <= ~clk_div; // Toggle divided clock output
    end
end

endmodule