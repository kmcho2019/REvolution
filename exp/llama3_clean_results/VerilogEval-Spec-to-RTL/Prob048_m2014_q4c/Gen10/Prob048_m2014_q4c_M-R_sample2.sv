module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always_ff @(posedge clk) begin
    if (r) begin
        // Synchronous reset condition: if r is high, reset q to 0
        q <= 1'b0;
    end else begin
        // Normal operation: assign d to q on the rising edge of clk
        q <= d;
    end
end

endmodule