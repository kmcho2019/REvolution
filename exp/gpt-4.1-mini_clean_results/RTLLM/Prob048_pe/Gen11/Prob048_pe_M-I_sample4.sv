module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    wire [63:0] product_full;
    wire [31:0] product_trunc;
    wire [32:0] sum_ext;

    assign product_full = a * b;
    assign product_trunc = product_full[31:0]; // truncate lower 32 bits
    assign sum_ext = {1'b0, c} + {1'b0, product_trunc};

    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= sum_ext[31:0];
        end
    end

endmodule