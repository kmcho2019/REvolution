module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Reset output to 0 when reset is active
    end else begin
        q <= d;    // Store input 'd' in output 'q' when reset is not active
    end
end

endmodule