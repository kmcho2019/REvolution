module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state logic using continuous assignments
    wire [511:0] next_q;

    // Internal bits (1 to 510)
    genvar i;
    generate
        for (i = 1; i < 511; i = i + 1) begin : rule110_logic
            assign next_q[i] = (q[i+1] & ~q[i] & q[i-1]) |  // 101 -> 1
                              (q[i+1] & ~q[i] & ~q[i-1]) |  // 100 -> 0 (not included)
                              (~q[i+1] & q[i]) |            // 0x1 -> 1 if center is 1
                              (~q[i+1] & ~q[i] & q[i-1]);   // 001 -> 1
        end
    endgenerate

    // Left boundary (bit 0)
    assign next_q[0] = (q[1] & ~q[0]) | (~q[1] & q[0]) | (~q[1] & ~q[0] & 1'b0);

    // Right boundary (bit 511)
    assign next_q[511] = (1'b0 & ~q[511]) | (~1'b0 & q[511]) | (~1'b0 & ~q[511] & q[510]);

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule