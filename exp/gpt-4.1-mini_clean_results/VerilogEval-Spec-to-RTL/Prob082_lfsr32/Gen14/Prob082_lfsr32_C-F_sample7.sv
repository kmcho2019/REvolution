module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask: bits 31, 21, 1, 0 (zero-based), corresponding to taps at positions 32,22,2,1
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            wire feedback = q[0];
            // Shift right by one and XOR feedback only on tapped bits
            q <= (q >> 1) ^ (TAP_MASK & {32{feedback}});
        end
    end

endmodule