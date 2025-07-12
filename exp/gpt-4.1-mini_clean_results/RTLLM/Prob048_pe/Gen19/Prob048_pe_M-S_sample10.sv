module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output reg [31:0]   c
);

    reg [63:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            acc <= 64'd0;
        else
            acc <= acc + a * b;
    end

    always @(posedge clk) begin
        c <= acc[31:0];
    end

endmodule