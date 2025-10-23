module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    reg [63:0] acc;

    wire [63:0] product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
            c <= 32'd0;
        end else begin
            acc <= acc + product;
            c <= acc[31:0];
        end
    end

endmodule