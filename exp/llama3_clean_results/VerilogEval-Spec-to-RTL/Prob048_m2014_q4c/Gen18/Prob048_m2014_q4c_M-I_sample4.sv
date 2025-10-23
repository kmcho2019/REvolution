module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Explicit reset condition
    end else begin
        q <= d; // Assign data if reset is not active
    end
end

endmodule