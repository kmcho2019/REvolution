module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset logic: direct blocking assignment to q when reset asserted
always @(posedge ar) begin
    q = 1'b0;
end

// Data latch on rising edge of clock, but only if not in reset
always @(posedge clk) begin
    if (!ar) begin
        q <= d;
    end
end

endmodule