module right_shifter(
    input clk,  // Clock signal
    input rst_n,  // Active low reset signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

// Initialize q to 0 when reset is active
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        q <= 8'd0;
    end else begin
        q <= {d, q[7:1]};  // Right shift q by 1 bit and insert d into the most significant position
    end
end

endmodule