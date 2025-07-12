module TopModule(
    input clk,
    input d,
    output reg q
);

// Directly update the output within the always blocks
always @(posedge clk) begin
    q <= d;
end

always @(negedge clk) begin
    q <= d;
end

endmodule