module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for positions 32,22,2,1 (bits 31,21,1,0)
    localparam [31:0] TAP_MASK = 32'h80400003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback is the current LSB q[0]
            // Next state is shifted right by 1 with feedback XORed at tapped bits
            q <= (q >> 1) ^ ( {32{q[0]}} & TAP_MASK );
        end
    end

endmodule