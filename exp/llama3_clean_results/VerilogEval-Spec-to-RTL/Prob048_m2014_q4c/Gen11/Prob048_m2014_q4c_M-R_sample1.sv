module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Refactored code using a different structure to implement the D flip-flop
always @(posedge clk) begin
    if (r) begin // Synchronous reset condition
        q <= 1'b0; // Reset output to 0
    end else begin
        q <= d; // Load input data
    end
end

endmodule