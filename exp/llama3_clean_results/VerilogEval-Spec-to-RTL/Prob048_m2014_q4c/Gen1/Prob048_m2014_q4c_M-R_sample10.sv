module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

always @(posedge clk) begin
    if (r) q <= 0; // Prioritize reset condition
    else q <= d;
end

endmodule