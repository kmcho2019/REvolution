module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Internal 64-bit register to hold the full accumulation to avoid overflow
    // However, since output is 32 bits, we can either keep 32 bits or 64 bits internally.
    // The problem states 32-bit output representing accumulated result,
    // so we will accumulate in 64-bit internal reg and output lower 32 bits for c.
    reg [63:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
            c <= 32'd0;
        end else begin
            acc <= acc + (a * b);
            c <= acc[31:0];
        end
    end

endmodule