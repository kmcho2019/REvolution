module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);
    // Tap mask for bit positions 32, 22, 2, 1 (0-based: 31,21,1,0)
    // So taps mask has bits 31, 21, 1, 0 set to 1
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    wire feedback;
    wire [31:0] shifted;
    wire [31:0] tapped_xor;

    assign feedback = q[0];
    assign shifted = q >> 1;
    // XOR feedback bit into the tapped positions of the shifted register
    assign tapped_xor = shifted ^ ({32{feedback}} & TAP_MASK);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= tapped_xor;
    end

endmodule