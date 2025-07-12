module TopModule(
    input clk,
    input d,
    output reg q
);

always @(posedge clk) begin
    q = d;  // Using blocking assignment for demonstration; however, in most sequential designs, non-blocking is preferred.
end

endmodule