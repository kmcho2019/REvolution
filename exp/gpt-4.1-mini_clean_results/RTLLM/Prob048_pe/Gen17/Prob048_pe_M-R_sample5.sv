module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    reg [31:0] acc;

    wire [63:0] product_full = a * b;
    wire [31:0] product_trunc = product_full[31:0];

    wire [32:0] sum_ext = {1'b0, acc} + {1'b0, product_trunc};
    wire        overflow = sum_ext[32];

    wire [31:0] next_acc = overflow ? 32'hFFFFFFFF : sum_ext[31:0];

    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
            c <= 32'd0;
        end else begin
            acc <= next_acc;
            c <= next_acc;
        end
    end

endmodule