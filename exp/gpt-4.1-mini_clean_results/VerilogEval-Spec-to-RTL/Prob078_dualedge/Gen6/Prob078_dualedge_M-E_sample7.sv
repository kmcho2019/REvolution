module TopModule (
    input  clk,
    input  d,
    output reg q
);

reg d_sync1, d_sync2;
reg d_sample;
reg toggle;

always @(posedge clk) begin
    // Synchronize input to clk domain
    d_sync1 <= d;
    d_sync2 <= d_sync1;
end

always @(posedge clk) begin
    // Toggle flip-flop on every clk edge to simulate double frequency enable
    toggle <= ~toggle;
end

always @(posedge clk) begin
    if (toggle) begin
        // On every alternate clk edge, sample the input data
        d_sample <= d_sync2;
    end
end

always @(posedge clk) begin
    // Capture sampled data into output register
    if (!toggle) begin
        q <= d_sample;
    end
end

endmodule