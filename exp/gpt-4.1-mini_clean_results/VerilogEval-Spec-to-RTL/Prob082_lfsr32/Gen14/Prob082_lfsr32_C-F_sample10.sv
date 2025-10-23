module TopModule (
    input  clk,
    input  reset,
    output reg [31:0] q
);

    // Define the tap mask for the Galois LFSR taps at bits 31, 21, 1, 0
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Shift right by 1 and XOR feedback taps masked by q[0]
            q <= (q >> 1) ^ (TAP_MASK & {32{q[0]}});
        end
    end

endmodule