module TopModule(
    input  clk,
    input  d,
    output reg q
);

reg toggle;

// Generate toggle signal that changes state every posedge clk
always @(posedge clk) begin
    toggle <= ~toggle;
end

// Sample d on every clk posedge when toggle=1, hold otherwise
always @(posedge clk) begin
    if (toggle)
        q <= d;
    // else q remains unchanged
end

endmodule