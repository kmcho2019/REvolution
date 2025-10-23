module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] state = 3'b000;  // bit 0: xor_ff, bit 1: and_ff, bit 2: or_ff

    wire d_xor = x ^ state[0];
    wire d_and = x & (~state[1]);
    wire d_or  = x | (~state[2]);

    always @(posedge clk) begin
        state <= {d_or, d_and, d_xor};
    end

    assign z = ~(|state);

endmodule