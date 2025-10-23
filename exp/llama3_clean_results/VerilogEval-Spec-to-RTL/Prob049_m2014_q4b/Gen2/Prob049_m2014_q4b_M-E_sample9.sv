module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg sel; // Select signal for the multiplexer
reg latch_out; // Output of the clock-enabled latch

always @(*) begin
    // Select signal for the multiplexer: 0 for reset, 1 for input d
    sel = ~ar;
end

always @(posedge clk) begin
    // Clock-enabled latch: capture the selected value on the positive edge of clk
    if (~ar) begin
        // Select input d when ar is low
        latch_out <= (sel)? d : 1'b0;
    end else begin
        // Reset to 0 when ar is high
        latch_out <= 1'b0;
    end
end

always @(*) begin
    // Assign the output of the latch to q
    q = latch_out;
end

endmodule