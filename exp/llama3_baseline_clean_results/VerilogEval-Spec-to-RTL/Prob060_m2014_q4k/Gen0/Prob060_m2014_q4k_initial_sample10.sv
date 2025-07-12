module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

reg [3:0] q;

always @(posedge clk) begin
    if (~resetn) begin
        q <= 4'b0000; // Reset all flip-flops
    end else begin
        q <= {q[2:0], in}; // Shift the bits and add the input
    end
end

assign out = q[3]; // The output is the output of the last flip-flop

endmodule