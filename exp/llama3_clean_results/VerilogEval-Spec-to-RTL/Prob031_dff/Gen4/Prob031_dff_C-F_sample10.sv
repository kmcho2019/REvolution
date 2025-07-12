module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q <= d; // Non-blocking assignment for proper sequential behavior
end

endmodule