module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions: 32,22,2,1 (1-based)
    // Corresponding zero-based bits: 31,21,1,0

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q[0]  <= q[31] ^ q[0];
            q[1]  <= q[0]  ^ q[21];
            q[21] <= q[20];
            q[31] <= q[30];
            q[30:22] <= q[29:21];
            q[20:2] <= q[19:1];
        end
    end

endmodule