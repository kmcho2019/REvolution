module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Internal 64-bit accumulator to prevent overflow on accumulation
    reg [63:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
            c <= 32'd0;
        end else begin
            acc <= acc + (a * b);
            c <= acc[31:0];  // output lower 32 bits of accumulated result
        end
    end

endmodule