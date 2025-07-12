module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg reset_n;

// Asynchronous reset logic: when ar is high, reset_n goes low immediately
always @(*) begin
    if (ar)
        reset_n = 1'b0;
    else
        reset_n = 1'b1;
end

// Positive edge clocked DFF with synchronous load enable based on reset_n
always @(posedge clk) begin
    if (!reset_n)
        q <= 1'b0;
    else
        q <= d;
end

endmodule