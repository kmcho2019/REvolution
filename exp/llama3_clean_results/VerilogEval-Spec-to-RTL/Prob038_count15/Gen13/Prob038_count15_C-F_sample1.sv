module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Combine simplicity with optimization considerations
always @(posedge clk) begin
    if (reset) begin
        // Explicitly reset the counter to 0 for clarity and good design practice
        q <= 4'd0; // Synchronous reset to 0
    end else begin
        // Direct incrementation maintains simplicity and efficiency
        // Considering wrap-around, no need for explicit bounds checking
        q <= q + 1;
    end
end

endmodule