module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

// Asynchronous reset block: immediately clears q when ar is high
always @(posedge ar or posedge clk) begin
    if (ar)
        q <= 1'b0;
    else
        q <= q; // maintain current value here as placeholder
end

// Synchronous block to capture d at posedge clk only when ar is low
always @(posedge clk) begin
    if (!ar)
        q <= d;
end

endmodule