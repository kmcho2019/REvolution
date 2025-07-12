module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = 32'h80200003; // taps at bits 31,21,1,0 zero-based

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else if (q[0]) begin
            // When feedback bit is 1, shift and XOR taps
            q <= (q >> 1) ^ TAP_MASK;
        end else begin
            // When feedback bit is 0, just shift right by 1, no XOR
            q <= q >> 1;
        end
    end

endmodule