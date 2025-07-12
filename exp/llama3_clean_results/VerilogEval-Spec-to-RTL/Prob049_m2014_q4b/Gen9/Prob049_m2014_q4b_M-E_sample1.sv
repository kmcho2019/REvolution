module TopModule(
    input  clk,
    input  ar,
    input  d,
    output reg q
);

reg internal_q;

always @(posedge ar) begin
    internal_q <= 1'b0; // Asynchronous reset
end

always @(posedge clk) begin
    if (!ar) begin
        internal_q <= d; // Update on positive clock edge if reset is not asserted
    end
    q <= internal_q; // Assign the internal signal to the output
end

endmodule