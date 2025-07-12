module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset: active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    reg [31:0] acc;

    wire [63:0] product;

    assign product = a * b;

    always @(posedge clk) begin
        if (rst)
            acc <= 32'd0;
        else
            acc <= acc + product[31:0];
    end

    always @(posedge clk) begin
        c <= acc;
    end

endmodule