module pe (
    input            clk,
    input            rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] c
);

    // 64-bit internal accumulator register for full precision accumulation
    reg [63:0] acc64;

    // 64-bit product of inputs
    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            acc64 <= 64'd0;
            c     <= 32'd0;
        end else begin
            acc64 <= acc64 + product;

            // Saturation logic:
            // If upper 32 bits of acc64 are nonzero, saturate output c to max 32-bit unsigned
            if (acc64[63:32] != 32'd0)
                c <= 32'hFFFF_FFFF;
            else
                c <= acc64[31:0];
        end
    end

endmodule