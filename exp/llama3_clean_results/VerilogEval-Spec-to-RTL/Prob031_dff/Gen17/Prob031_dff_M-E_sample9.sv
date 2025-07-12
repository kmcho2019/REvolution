module TopModule(
    input clk,
    input d,
    output reg q
);

// Master latch
reg master_q;
always @(posedge clk or negedge clk) begin
    if (clk) begin
        // Capture input on rising edge
        master_q <= d;
    end else begin
        // Hold the value
        master_q <= master_q;
    end
end

// Slave latch
always @(posedge clk or negedge clk) begin
    if (clk) begin
        // Hold the value
        q <= q;
    end else begin
        // Transfer master latch value to output on falling edge
        q <= master_q;
    end
end

endmodule