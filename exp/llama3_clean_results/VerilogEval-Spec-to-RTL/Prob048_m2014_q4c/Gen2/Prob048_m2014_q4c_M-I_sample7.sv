module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

// Single always block sensitive to the positive clock edge
always @(posedge clk) begin
    // Check for synchronous reset condition
    if (r) begin
        // Reset output to 0 when reset is high
        q <= 1'b0;
    end else begin
        // Update output with input d when reset is low
        q <= d;
    end
end

endmodule