module pe (
    input wire clk,
    input wire rst,
    input wire signed [31:0] a,
    input wire signed [31:0] b,
    output reg signed [31:0] c
);

    // Combinational logic for multiplication
    wire signed [63:0] full_product;
    assign full_product = a * b;

    // Registered accumulation with synchronous reset
    always @(posedge clk) begin
        if (rst) begin
            c <= 32'sd0;
        end else begin
            // Truncate to 32 bits before accumulation to save area
            c <= c + full_product[31:0];
        end
    end

endmodule