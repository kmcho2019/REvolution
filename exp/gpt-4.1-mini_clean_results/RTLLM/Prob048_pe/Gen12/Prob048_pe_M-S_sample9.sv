module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc;

    always @(posedge clk) begin
        if (rst)
            acc <= 64'b0;
        else
            acc <= acc + a * b;
    end

    assign c = acc[31:0];

endmodule