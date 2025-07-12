module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Using a synchronous reset with a case statement to describe the behavior
always @(posedge clk) begin
    if (r) begin // Active high synchronous reset
        q <= 1'b0; // Reset output to 0
    end else begin
        q <= d; // Load input data on rising edge of clk
    end
end

endmodule