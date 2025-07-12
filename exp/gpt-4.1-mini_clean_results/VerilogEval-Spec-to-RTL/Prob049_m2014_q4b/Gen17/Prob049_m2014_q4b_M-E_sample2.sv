module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Asynchronous reset block
always @(posedge ar) begin
    q <= 1'b0;
end

// Synchronous data latch block, active only when reset is not asserted
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule