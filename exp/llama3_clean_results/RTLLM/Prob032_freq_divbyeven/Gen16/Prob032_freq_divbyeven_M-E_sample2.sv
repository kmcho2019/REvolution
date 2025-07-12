// Frequency divider module using circular buffer-based counter
module freq_diveven #(
    parameter NUM_DIV = 2  // Even number division factor, must be greater than 0
) (
    input clk,        // Input clock signal
    input rst_n,      // Active-low reset signal
    output reg clk_div // Divided clock output signal
);

// Validate if NUM_DIV is an even number
generate
    if (NUM_DIV <= 0 || (NUM_DIV % 2)!= 0) begin
        $error("NUM_DIV must be an even number greater than 0");
    end
endgenerate

// Calculate the required width for the buffer
localparam BUF_WIDTH = NUM_DIV / 2;

reg [BUF_WIDTH-1:0] buffer;  // Circular buffer to generate clk_div signal
reg [BUF_WIDTH-1:0] idx;     // Index to track the current position in the buffer

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Initialize the buffer with alternating 0s and 1s
        for (int i = 0; i < BUF_WIDTH; i++) begin
            buffer[i] = (i % 2);
        end
        idx <= 0;
        clk_div <= 0;
    end else begin
        // Shift the buffer content to the right and update the idx
        for (int i = BUF_WIDTH - 1; i > 0; i--) begin
            buffer[i] <= buffer[i - 1];
        end
        buffer[0] <= buffer[BUF_WIDTH - 1];
        idx <= (idx + 1) % BUF_WIDTH;
        // Generate the clk_div signal based on the buffer content
        clk_div <= buffer[idx];
    end
end

endmodule

// Example testbench to instantiate the freq_diveven module
module freq_diveven_tb;
    reg clk;
    reg rst_n;
    wire clk_div;

    freq_diveven #(.NUM_DIV(4)) u_freq_diveven (
       .clk(clk),
       .rst_n(rst_n),
       .clk_div(clk_div)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        #10;
        rst_n = 1;
        forever #5 clk = ~clk;
    end

    initial begin
        #100;
        $finish;
    end
endmodule