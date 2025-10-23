module TopModule(
    input clk,
    input d,
    output reg q
);

reg clk_int;

// Generate an internal clock that is twice the frequency of the original clock
// with a phase shift to capture data on both edges
always @(posedge clk) begin
    clk_int <= ~clk_int;
end

// Use the internal clock to capture data
always @(posedge clk_int) begin
    if (clk == 1'b1) begin // Positive edge of original clock
        q <= d;
    end else begin // Negative edge of original clock
        q <= d;
    end
end

endmodule