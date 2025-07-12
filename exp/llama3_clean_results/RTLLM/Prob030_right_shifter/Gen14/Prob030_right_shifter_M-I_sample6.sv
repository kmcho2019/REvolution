module right_shifter(
    input clk,  // Clock signal
    input d,    // Input signal to be right-shifted
    output reg [7:0] q  // Output signal representing the result of the right shift operation
);

always @(posedge clk) begin
    if (!clk) begin  // Assuming a reset condition when clk is low
        q <= 8'd0;  // Initialize q to 0 on reset
    end else begin
        q <= {d, q[7:1]};  // Right shift and insert new input
    end
end

endmodule