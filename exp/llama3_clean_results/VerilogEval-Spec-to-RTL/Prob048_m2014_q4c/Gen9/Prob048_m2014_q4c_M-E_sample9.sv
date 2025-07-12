module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Using a 2-to-1 multiplexer to select between input data and reset value
always @(posedge clk) begin
    q <= r ? 1'b0 : d; // If r is high, select reset value (0), otherwise select input data (d)
end

endmodule