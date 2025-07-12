module TopModule(
    input clk,
    input d,
    output reg q
);

// Positive-edge triggered flip-flop
always @(posedge clk) begin
    q <= d;
end

// Negative-edge triggered flip-flop
always @(negedge clk) begin
    q <= d;
end

endmodule