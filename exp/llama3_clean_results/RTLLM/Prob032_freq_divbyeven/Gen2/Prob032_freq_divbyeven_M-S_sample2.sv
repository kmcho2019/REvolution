module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

parameter NUM_DIV = 8; // Division factor, must be an even number

// Ensure NUM_DIV is an even number
initial begin
    if (NUM_DIV % 2!= 0) begin
        $display("Error: NUM_DIV must be an even number.");
        $finish;
    end
end

reg [3:0] cnt; // 4-bit counter

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 4'd0; // Reset counter
            clk_div <= ~clk_div; // Toggle divided clock
        end
    end
end

endmodule