// Refactored version of the frequency divider module
module freq_diveven (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output wire clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Counter register
reg [3:0] cnt;

// Output logic expressed through assign
assign clk_div = (cnt == (NUM_DIV / 2 - 1)) ? ~clk_div : clk_div;

// Always block for sequential counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter on reset
        cnt <= 4'd0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        // If the counter reaches the limit, reset it
        cnt <= 4'd0;
    end else begin
        // If the counter is less than the limit, increment it
        cnt <= cnt + 1;
    end
end

endmodule