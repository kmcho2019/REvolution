module freq_diveven(
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the division factor, ensuring it's an even number
parameter NUM_DIV = 8; // Must be an even number and not exceed 32 (2^4 - 1) for 4-bit counter

// Ensure NUM_DIV is within valid range and an even number
initial begin
    if ((NUM_DIV % 2 != 0) || (NUM_DIV > 32)) begin
        $display("Error: NUM_DIV must be an even number and not exceed 32.");
        $finish;
    end
end

// 4-bit counter
reg [3:0] cnt;

// Always block for handling clock and reset
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset counter and divided clock output on active-low reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter if it hasn't reached half of the division factor minus one
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock when counter reaches the limit
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule