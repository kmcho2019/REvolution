// Improved version of the frequency divider module
module freq_diveven #(
    parameter NUM_DIV = 8 // Must be an even number
) (
    input  wire clk,    // Input clock signal
    input  wire rst_n,  // Active-low reset signal
    output reg  clk_div  // Divided clock output signal
);

// Calculate the counter width based on NUM_DIV
localparam CNT_WIDTH = $clog2(NUM_DIV / 2);

// Counter register
reg [CNT_WIDTH-1:0] cnt;

// Always block for sequential counter logic
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and output on reset
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= 1'b0;
    end else if (cnt == (NUM_DIV / 2 - 1)) begin
        // If the counter reaches the limit, reset it and toggle the output
        cnt <= {CNT_WIDTH{1'b0}};
        clk_div <= ~clk_div;
    end else begin
        // If the counter is less than the limit, increment it
        cnt <= cnt + 1;
    end
end

endmodule