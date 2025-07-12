module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions are bits 31, 21, 1, and 0 (zero-based)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // feedback bit is q[0]
            wire feedback = q[0];

            // Shift right by 1
            reg [31:0] shifted = q >> 1;

            // Conditionally XOR only the tap bits with feedback
            q <= shifted ^ (TAP_MASK & {32{feedback}});
        end
    end

endmodule