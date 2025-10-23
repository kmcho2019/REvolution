module TopModule(
    input clk,
    input d,
    output reg q
);

reg toggle;  // Output of T flip-flop

// T flip-flop
always @(posedge clk or negedge clk) begin
    toggle <= ~toggle;
end

// Dual-edge triggered flip-flop behavior using T flip-flop
always @(posedge clk or negedge clk) begin
    if (toggle) begin
        q <= d;
    end
end

initial begin
    toggle = 1'b1;  // Initialize T flip-flop
    q = 1'b0;       // Initialize output
end

endmodule