module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

initial q = 8'd0;  // Initialize q to 0
always @(posedge clk) begin
    reg [7:0] temp_q;  // Temporary variable to store the shifted value of q
    temp_q = {d, q[7:1]};  // Right shift q by 1 bit and insert d into the most significant position
    q <= temp_q;  // Assign the shifted value back to q
end

endmodule