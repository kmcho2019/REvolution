module TopModule (
    input  clk,
    input  ar,
    input  d,
    output reg q
);

// Separate asynchronous reset handling block
always @(posedge clk) begin
    if (!ar)       // update q only if asynchronous reset not asserted
        q <= d;
end

// Asynchronous reset logic separate from clock domain
always @(posedge ar) begin
    q <= 1'b0;     // asynchronously clear q when ar asserted
end

endmodule