module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    reg [63:0] acc;
    reg [63:0] product;

    // Combinational block to calculate product
    always @(*) begin
        product = a * b;
    end

    // Sequential block to accumulate product and update output
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
            c <= 32'd0;
        end else begin
            acc <= acc + product;
            c <= acc[31:0];
        end
    end

endmodule