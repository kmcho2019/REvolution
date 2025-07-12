module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg  [63:0] acc;
    wire [63:0] product;
    wire [63:0] next_acc;

    assign product = a * b;
    assign next_acc = acc + product;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= next_acc;
        end
    end

    assign c = acc[31:0];

endmodule