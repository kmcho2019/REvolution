module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 32, 22, 2, and 1 => bits [31], [21], [1], [0]
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else begin
            // Extract feedback bit (LSB)
            wire feedback = q[0];
            // Shift right by 1
            reg [31:0] shifted = q >> 1;
            // Conditionally XOR tapped bits with feedback
            // If feedback is 1, flip tapped bits in shifted register
            if (feedback)
                q <= shifted ^ TAP_MASK;
            else
                q <= shifted;
        end
    end

endmodule