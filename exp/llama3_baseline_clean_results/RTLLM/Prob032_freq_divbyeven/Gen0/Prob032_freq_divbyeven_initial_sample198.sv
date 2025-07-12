module freq_diveven #(
    parameter NUM_DIV = 10 // Must be an even number
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [3:0] cnt; // 4-bit counter

// Check if NUM_DIV is even at compile time
initial begin
    if (NUM_DIV % 2 != 0) begin
        $display("Error: NUM_DIV (%0d) must be an even number.", NUM_DIV);
        $finish;
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Active-low reset
        cnt <= 4'b0; // Initialize counter to zero
        clk_div <= 1'b0; // Initialize divided clock to zero
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // Increment counter if less than half of NUM_DIV - 1
        end else begin
            cnt <= 4'b0; // Reset counter when it reaches the limit
            clk_div <= ~clk_div; // Toggle divided clock output
        end
    end
end

endmodule