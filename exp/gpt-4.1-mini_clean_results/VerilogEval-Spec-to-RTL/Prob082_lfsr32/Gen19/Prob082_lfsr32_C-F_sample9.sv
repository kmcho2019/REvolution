module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap positions at bits 32, 22, 2, and 1 correspond to bits 31, 21, 1, and 0 (0-based indexing)
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback bit is the current LSB of q
            wire feedback = q[0];
            // Shift right by 1 bit
            wire [31:0] shifted = q >> 1;
            // XOR only the tapped bits with feedback
            // This toggles tapped bits if feedback == 1, else no change
            q <= shifted ^ ({32{feedback}} & TAP_MASK);
        end
    end

endmodule