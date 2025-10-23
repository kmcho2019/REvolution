module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Reset q to 0 when r is high
    end else begin
        q <= d; // Capture d and store it in q
    end
end

endmodule