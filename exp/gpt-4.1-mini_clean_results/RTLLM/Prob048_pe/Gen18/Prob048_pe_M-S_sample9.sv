module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [31:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            acc <= 32'd0;
        else
            acc <= acc + a * b;
    end

    assign c = acc;

endmodule