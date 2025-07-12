module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

// Using a synchronous reset with a ternary operator for concise expression
always @(posedge clk) begin
    if (r) begin // Explicitly reset output to 0 when r is high
        q <= 1'b0;
    end else begin // Otherwise, load input data
        q <= d;
    end
end

endmodule