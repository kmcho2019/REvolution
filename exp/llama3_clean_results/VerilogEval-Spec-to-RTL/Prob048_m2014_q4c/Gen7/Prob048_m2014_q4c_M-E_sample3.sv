module TopModule(
    input  clk,
    input  d,
    input  r,
    output reg q
);

reg reset_q;

// First stage: Handle reset condition
always @(posedge clk) begin
    if (r) begin
        reset_q <= 1'b0;
    end else begin
        reset_q <= 1'b1;
    end
end

// Second stage: Capture input data on rising edge of clock
always @(posedge clk) begin
    if (~reset_q) begin
        q <= 1'b0; // Reset output to 0
    end else begin
        q <= d; // Load input data
    end
end

endmodule