module right_shifter(
    input clk, // Clock signal
    input rst_n, // Active low reset signal
    input d,   // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize the q register to 0
initial q = 8'b0;

// Always block to perform the right shift operation on the rising edge of the clock
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset the q register to 0 on active low reset
        q <= 8'b0;
    end else begin
        // Right shift the contents of q by one bit and insert d into the most significant position
        q <= {d, q[7:1]};
    end
end

endmodule