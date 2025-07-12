module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Tap mask for bits 32, 22, 2, and 1 (0-based positions: 31,21,1,0)
    localparam [31:0] TAP_MASK = 32'h80200003;

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            reg [31:0] next_q;
            next_q = q >> 1;
            if (q[0])
                next_q = next_q ^ TAP_MASK;
            q <= next_q;
        end
    end

endmodule