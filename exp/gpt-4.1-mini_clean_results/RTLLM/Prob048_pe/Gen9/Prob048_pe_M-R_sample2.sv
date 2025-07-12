module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    wire [63:0] product;
    reg  [63:0] acc;

    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'b0;
        end else begin
            acc <= acc + product;
        end
    end

    assign c = acc[31:0];

endmodule