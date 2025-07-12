module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Define tap mask with bits 31, 21, 1, 0 set (0-based indexing)
    // Tap positions: 32,22,2,1 correspond to bits [31], [21], [1], [0]
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit is current LSB
            // Shift right by one bit, insert 0 at MSB
            // XOR the feedback bit with tapped bits after shift using mask
            q <= (q >> 1) ^ (TAP_MASK & {32{q[0]}});
        end
    end

endmodule