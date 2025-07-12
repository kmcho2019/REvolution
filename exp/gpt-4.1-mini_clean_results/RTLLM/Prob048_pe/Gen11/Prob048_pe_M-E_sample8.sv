module pe (
    input           clk,
    input           rst,
    input  [31:0]   a,
    input  [31:0]   b,
    output [31:0]   c
);

    reg [63:0] acc;
    reg [63:0] product;

    // Combinational multiplication
    always @* begin
        product = a * b;
    end

    // Accumulate with asynchronous reset
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            acc <= 64'd0;
        end else begin
            acc <= acc + product;
        end
    end

    assign c = acc[31:0];

endmodule