module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset logic - drives q low immediately if reset asserted
always @(ar) begin
    if (ar)
        q <= 1'b0;
end

// Synchronous data capture on rising edge of clk, only if reset is not asserted
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule