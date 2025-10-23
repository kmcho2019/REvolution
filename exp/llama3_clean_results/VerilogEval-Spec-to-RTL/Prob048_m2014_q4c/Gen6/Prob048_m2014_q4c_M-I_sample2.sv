module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    if (r) begin
        q <= 1'b0; // Explicitly reset q to 0 when r is high
    end else begin
        q <= d; // Otherwise, set q to the value of d
    end
end

endmodule