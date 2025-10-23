module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Explicitly define the bit width for clarity
    end else begin
        q <= d;
    end
end

endmodule