module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Left boundary cell (i=0)
    assign next_q[0] = (~q[1] & q[0]) |        // Center=1, Left=0
                      (~q[1] & 1'b0) |         // Right=0 (boundary), Left=0
                      (q[1] & q[0] & 1'b0);    // Left=1, Center=1, Right=0

    // Middle cells (i=1 to 510)
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110
            assign next_q[i] = (~q[i+1] & q[i]) |          // Center=1, Left=0
                              (~q[i+1] & q[i-1]) |        // Right=1, Left=0
                              (q[i+1] & q[i] & ~q[i-1]);  // Left=1, Center=1, Right=0
        end
    endgenerate

    // Right boundary cell (i=511)
    assign next_q[511] = (1'b0 & q[511]) |         // Center=1, Left=0 (boundary)
                        (1'b0 & q[510]) |          // Right=1, Left=0 (boundary)
                        (1'b0 & q[511] & ~q[510]); // Left=0 (boundary) makes this term always 0

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule