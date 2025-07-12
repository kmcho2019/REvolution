module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] next_q;

always @(*) begin
    // Calculate the next state of the LFSR
    next_q = {q[0] ^ q[21] ^ q[1] ^ q[0], q[31:1]};
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset to the specified initial value
        q <= 32'h1;
    end else begin
        // Update the state of the LFSR
        q <= next_q;
    end
end

endmodule