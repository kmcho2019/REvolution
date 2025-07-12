module TopModule(
    input clk,
    input d,
    output reg q
);

reg internal_capture;

// Capture latch is enabled during the low phase of clk
always @(negedge clk) begin
    internal_capture <= d;
end

// Output latch is enabled during the high phase of clk
always @(posedge clk) begin
    q <= internal_capture;
end

endmodule