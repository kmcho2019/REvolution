module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = 32'h80200003; // taps at bits 31,21,1,0 (0-based)

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            if (q[0])
                q <= (q >> 1) ^ TAP_MASK;
            else
                q <= q >> 1;
        end
    end

endmodule