module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin // Explicitly resetting q to 0 when r is high
        q <= 1'b0; // Using bit notation for clarity
    end else begin
        q <= d;
    end
end

endmodule