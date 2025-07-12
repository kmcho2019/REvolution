module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset block - immediate reset to 0 when ar is asserted
always @(posedge ar or negedge ar) begin
    if (ar)
        q <= 1'b0;
end

// Synchronous data latch - update q on rising edge of clk if reset not active
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule