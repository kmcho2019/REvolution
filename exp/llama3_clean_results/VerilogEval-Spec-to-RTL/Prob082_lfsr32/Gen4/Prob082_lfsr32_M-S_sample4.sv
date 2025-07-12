module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the feedback
        reg fb;
        fb = q[0] ^ q[1] ^ q[21] ^ q[31];

        // Shift the register to the right and apply the feedback
        q <= {fb, q[31:1]};
    end
end

endmodule