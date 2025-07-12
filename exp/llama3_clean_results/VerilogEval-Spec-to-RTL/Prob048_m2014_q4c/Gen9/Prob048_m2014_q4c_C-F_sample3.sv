module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= #0 0; // Reset condition
    end else begin
        q <= #0 d; // Non-blocking assignment for input data
    end
end

endmodule