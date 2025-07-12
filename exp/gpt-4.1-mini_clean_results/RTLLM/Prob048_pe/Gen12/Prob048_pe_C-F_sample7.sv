module pe (
    input           clk,
    input           rst,    // synchronous active-high reset
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0] c
);

    reg [31:0] acc;

    wire [63:0] product = a * b;
    wire [31:0] product_trunc = product[31:0];
    wire [32:0] sum_ext = {1'b0, acc} + {1'b0, product_trunc};
    wire overflow = sum_ext[32];

    always @(posedge clk) begin
        if (rst) begin
            acc <= 32'd0;
            c   <= 32'd0;
        end else begin
            if (overflow) begin
                acc <= 32'hFFFFFFFF;
                c   <= 32'hFFFFFFFF;
            end else begin
                acc <= sum_ext[31:0];
                c   <= sum_ext[31:0];
            end
        end
    end

endmodule