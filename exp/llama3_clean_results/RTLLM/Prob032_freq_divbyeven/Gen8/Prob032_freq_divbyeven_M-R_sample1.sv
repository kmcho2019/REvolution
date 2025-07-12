// Refactored version of the frequency divider module
module freq_diveven (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output reg  clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Counter register
reg [3:0] cnt;

// Always block for sequential counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output on reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        // If the counter reaches the limit, reset it and toggle the output
        cnt <= 4'd0;
        clk_div <= ~clk_div;
    end else begin
        // If the counter is less than the limit, increment it
        cnt <= cnt + 1;
    end
end

endmodule