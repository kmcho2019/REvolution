module pe (
    input  wire        clk,
    input  wire        rst,    // synchronous reset, active high
    input  wire [31:0] a,
    input  wire [31:0] b,
    output reg  [31:0] c
);

    reg [63:0] acc;
    wire [63:0] product;

    assign product = a * b;

    always @(posedge clk) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    // output lower 32 bits of accumulator
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'd0;
        end else begin
            c <= acc[31:0];
        end
    end

endmodule