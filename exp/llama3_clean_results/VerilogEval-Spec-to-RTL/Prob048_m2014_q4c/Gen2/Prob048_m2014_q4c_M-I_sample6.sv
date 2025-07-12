module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        // Reset q to 0 when r is high
        q <= 1'b0;
    end else begin
        // Update q with d when r is low
        q <= d;
    end
end

endmodule