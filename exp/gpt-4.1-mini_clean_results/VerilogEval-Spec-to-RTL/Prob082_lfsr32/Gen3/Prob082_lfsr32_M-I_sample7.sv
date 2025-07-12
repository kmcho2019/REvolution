module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Incorporate feedback bit q[0] as a mask multiplier to TAP_MASK
            // This removes the conditional assignment and associated mux
            q <= (q >> 1) ^ (TAP_MASK & {32{q[0]}});
        end
    end

endmodule