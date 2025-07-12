module freq_diveven #(
    parameter NUM_DIV = 4 // Must be an even number
) (
    input clk,
    input rst_n,
    output reg clk_div
);

reg [3:0] cnt; // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        cnt <= cnt + 1'b1;
    end else begin
        cnt <= 4'd0;
        clk_div <= ~clk_div; // Toggle the divided clock output
    end
end

initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV must be an even number.");
        $finish;
    end
end

endmodule