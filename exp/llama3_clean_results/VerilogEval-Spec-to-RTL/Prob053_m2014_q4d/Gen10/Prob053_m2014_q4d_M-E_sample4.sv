module TopModule(
    input clk,
    input in,
    output reg out = 1'b0 // Initialize out to 0
);

// Single always block for both combinational and sequential logic
always @(posedge clk or in) begin
    if (posedge clk) begin // Update out at the rising edge of clk
        out <= in ^ out; // Compute next state using current state and input
    end
end

endmodule