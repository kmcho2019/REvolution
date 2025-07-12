module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [31:0] acc;

    wire [63:0] product = a * b;
    wire [32:0] sum_ext = {1'b0, acc} + product[31:0];
    wire overflow = sum_ext[32];
    wire [31:0] next_acc = overflow ? 32'hFFFF_FFFF : sum_ext[31:0];

    always @(posedge clk) begin
        if (rst) 
            acc <= 32'd0;
        else
            acc <= next_acc;
    end

    assign c = acc;

endmodule