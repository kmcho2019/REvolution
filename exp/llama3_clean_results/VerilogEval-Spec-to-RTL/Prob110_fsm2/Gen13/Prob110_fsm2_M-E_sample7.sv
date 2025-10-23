module TopModule(
    input  clk,    // clock (not used in this implementation)
    input  areset, // asynchronous reset
    input  j,      // input j
    input  k,      // input k
    output out     // output
);

reg q; // state of the SR latch

// SR latch with asynchronous reset
always @(j or k or areset) begin
    if (areset) begin
        q <= 0;
    end else if (j && !q) begin
        q <= 1;
    end else if (k && q) begin
        q <= 0;
    end
end

// Output logic directly from state
assign out = q;

endmodule