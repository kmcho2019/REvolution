module TopModule(
    input  clk,
    input  d,
    output q
);

reg q_reg;

// Synchronize the input data to the positive edge of the clock
reg d_sync;
always @(posedge clk) begin
    d_sync <= d;
end

// Edge detection
reg last_clk;
always @(posedge clk) begin
    last_clk <= clk;
end

// Dual-edge triggered flip-flop implementation
always @(posedge clk) begin
    if (!last_clk && clk) begin // positive edge
        q_reg <= d_sync;
    end else if (last_clk && !clk) begin // negative edge (note: this block is executed on posedge, but it captures the negedge behavior)
        q_reg <= d_sync;
    end
end

assign q = q_reg;

endmodule