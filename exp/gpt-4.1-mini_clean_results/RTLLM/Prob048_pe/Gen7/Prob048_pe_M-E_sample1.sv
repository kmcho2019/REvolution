module pe (
    input wire clk,
    input wire rst,             // asynchronous reset: active high
    input wire [31:0] a,
    input wire [31:0] b,
    output reg [31:0] c
);

    reg [31:0] acc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            acc <= 32'd0;
        else
            acc <= acc + (a * b)[31:0];
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            c <= 32'd0;
        else
            c <= acc;
    end

endmodule