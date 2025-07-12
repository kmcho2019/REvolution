module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk or posedge r) begin
    if (r) begin
        q <= 1'b0; // Reset condition takes precedence
    end else begin
        q <= d; // Update 'q' with 'd' on rising edge of 'clk'
    end
end

endmodule