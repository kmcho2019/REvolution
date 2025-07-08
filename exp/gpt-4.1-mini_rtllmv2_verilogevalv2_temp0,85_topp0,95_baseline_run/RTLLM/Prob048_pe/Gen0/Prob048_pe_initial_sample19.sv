module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    // Internal 64-bit accumulator to hold intermediate sum without overflow
    reg [63:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'b0;
            c <= 32'b0;
        end else begin
            acc <= acc + (a * b);
            c <= acc[31:0];
        end
    end

endmodule