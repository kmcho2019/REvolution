module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 0; // Reset output to 0 when r is high
    end else begin
        q <= d; // Capture input d when r is low
    end
end

endmodule