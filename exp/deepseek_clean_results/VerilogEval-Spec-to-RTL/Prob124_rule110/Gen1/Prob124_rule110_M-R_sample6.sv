module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [511:0] next_q;

    // Left boundary cell (i=0)
    assign next_q[0] = (~0 & q[0] & q[1]) | (~0 & q[0] & ~q[1]) | 
                      (~0 & ~q[0] & q[1]) | (0 & q[0] & q[1]) | 
                      (0 & q[0] & ~q[1]) | (0 & ~q[0] & q[1]);

    // Middle cells (i=1 to 510)
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110
            assign next_q[i] = (~q[i-1] & q[i] & q[i+1]) | (~q[i-1] & q[i] & ~q[i+1]) | 
                              (~q[i-1] & ~q[i] & q[i+1]) | (q[i-1] & q[i] & ~q[i+1]);
        end
    endgenerate

    // Right boundary cell (i=511)
    assign next_q[511] = (~q[510] & q[511] & 0) | (~q[510] & q[511] & ~0) | 
                         (~q[510] & ~q[511] & 0) | (q[510] & q[511] & ~0);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule