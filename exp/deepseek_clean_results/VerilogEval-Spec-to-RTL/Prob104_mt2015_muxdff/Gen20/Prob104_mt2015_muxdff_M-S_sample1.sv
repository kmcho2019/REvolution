module TopModule (
    input clk,
    input L,
    input q_in,    // Feedback input from other flip-flops
    input r_in,    // Parallel load input
    output reg Q   // Output register
);

always @(posedge clk) begin
    if (L)
        Q <= r_in;  // Load mode
    else
        Q <= q_in;  // Feedback mode
end

endmodule