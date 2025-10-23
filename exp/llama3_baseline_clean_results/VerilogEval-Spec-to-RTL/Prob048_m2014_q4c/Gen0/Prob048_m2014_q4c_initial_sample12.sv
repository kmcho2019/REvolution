module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0;  // Reset to 0 if r is high
    end else begin
        q <= d;    // Store input d in q if r is low
    end
end

endmodule