module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Calculate the next state for the MSB using the taps
wire next_msb = q[31] ^ q[22] ^ q[2] ^ q[1];

// Combinatorial logic for next state
always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        q <= {next_msb, q[31:1]};
    end
end

endmodule