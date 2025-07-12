module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    // Next state calculation
    wire [511:0] next_q;

    // Boundary bits (leftmost and rightmost)
    assign next_q[511] = (q[511] & ~q[510]) | (~q[511] & q[510]);  // Right neighbor is 0
    assign next_q[0] = (q[1] & q[0]) | (~q[1] & (q[0] | q[1]));    // Left neighbor is 0

    // Core bits (bits 1 to 510)
    assign next_q[510:1] = (q[511:2] & q[510:1] & ~q[509:0]) |  // 110 pattern
                          (q[511:2] & ~q[510:1] & q[509:0]) |   // 101 pattern
                          (~q[511:2] & q[510:1]) |              // 011 or 010
                          (~q[511:2] & q[509:0]);               // 001 pattern

    // State transition
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule