module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    // Use non-blocking assignment for sequential logic
    q <= d;
end

endmodule