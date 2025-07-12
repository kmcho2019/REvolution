module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for taps at bits 31,21,1,0 (0-based)
    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    // Combinational feedback bit from current q LSB
    wire feedback = q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by 1
            // XOR tapped bits with feedback if feedback == 1
            // Insert feedback at MSB
            q <= {feedback, ((q >> 1) ^ (TAP_MASK & {32{feedback}}))};
        end
    end

endmodule