module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

always @(posedge clk) begin
    // Using ternary operator to simplify the logic
    q <= r ? 1'b0 : d;
end

endmodule