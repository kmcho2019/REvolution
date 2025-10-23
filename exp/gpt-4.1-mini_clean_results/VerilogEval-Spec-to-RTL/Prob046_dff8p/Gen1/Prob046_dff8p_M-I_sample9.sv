module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

// Enable flip-flops only when reset is active or input differs from stored q
wire enable = reset | (d != q);

always @(negedge clk) begin
    if (reset) begin
        q <= 8'h34;
    end else if (enable) begin
        q <= d;
    end
    // else hold current value (no change)
end

endmodule