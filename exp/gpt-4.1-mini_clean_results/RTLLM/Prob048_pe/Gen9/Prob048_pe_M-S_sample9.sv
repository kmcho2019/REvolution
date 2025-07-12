module pe (
    input  wire        clk,
    input  wire        rst,    // asynchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    wire [63:0] product;

    assign product = a * b;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= c + product[31:0];  // accumulate lower 32 bits, truncating product
        end
    end

endmodule