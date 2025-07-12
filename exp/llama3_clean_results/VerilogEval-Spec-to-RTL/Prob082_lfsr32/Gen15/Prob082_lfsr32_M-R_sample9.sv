module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

    localparam TAP_32 = 31;
    localparam TAP_22 = 21;
    localparam TAP_2  = 1;
    localparam TAP_1  = 0;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[31] <= q[30];
            q[30:22] <= q[29:21];
            q[21] <= q[20] ^ q[0];
            q[20:2] <= q[19:1];
            q[1] <= q[0] ^ q[0];  // Corrected to maintain previous value
            q[0] <= q[31] ^ q[21] ^ q[2] ^ q[1];  // Corrected according to Galois LFSR
        end
    end

endmodule