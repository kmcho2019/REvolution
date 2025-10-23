module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Taps at bits 32, 22, 2, and 1 correspond to bits 31, 21, 1, and 0 in 0-based indexing
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= (q >> 1) ^ (q[0] ? TAP_MASK : 0);
    end

endmodule