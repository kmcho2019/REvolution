module freq_diveven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

// Define the division factor as a parameter
parameter NUM_DIV = 8; // Must be an even number

// Counter register
reg [3:0] cnt;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the counter and the divided clock output on reset
        cnt <= 4'd0; // Reset to 0
        clk_div <= 1'b0; // Reset to 0
    end else begin
        if (cnt == (NUM_DIV - 1)) begin
            // If the counter reaches the limit, reset it and toggle the divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end else begin
            // If the counter is less than the limit, increment it
            cnt <= cnt + 1;
        end
    end
end

endmodule