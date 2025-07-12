module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        // Reset output to 0 when reset signal is high
        q <= 1'b0;
    end else begin
        // Update output with input d when reset is low
        q <= d;
    end
end

endmodule