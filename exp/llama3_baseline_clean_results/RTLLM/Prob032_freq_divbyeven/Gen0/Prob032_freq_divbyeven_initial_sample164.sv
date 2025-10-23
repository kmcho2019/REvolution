module freq_diveven (
    input clk,
    input rst_n,
    output reg clk_div
);

// Define the division factor as a parameter, must be an even number
parameter NUM_DIV = 4;

// Initialize the counter
reg [3:0] cnt = 0;

// Internal signal to track the divided clock
reg div_clk_int = 1'b0;

// Set the divided clock output high at the start for correct toggling
initial clk_div = 1'b1;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and divided clock signal on active-low reset
        cnt <= 4'b0;
        div_clk_int <= 1'b0;
        clk_div <= 1'b1; // Reset divided clock to high
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            // Increment counter until it reaches half of NUM_DIV - 1
            cnt <= cnt + 1;
        end else begin
            // Reset counter and toggle divided clock output
            cnt <= 4'b0;
            div_clk_int <= ~div_clk_int; // Toggle internal signal
            clk_div <= div_clk_int; // Update output with toggled value
        end
    end
end

endmodule