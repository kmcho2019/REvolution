module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc;
    wire [63:0] product;

    assign product = a * b;

    always @(posedge clk) begin
        if (rst)
            acc <= 64'd0;
        else
            acc <= acc + product;
    end

    assign c = acc[31:0];

endmodule