module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Galois LFSR taps at bits 31, 21, 1, 0 (0-based)
            // Shift right by 1 and XOR feedback into taps
            q <= (q >> 1) ^ ({32{q[0]}} & 32'h80200003);
        end
    end

endmodule