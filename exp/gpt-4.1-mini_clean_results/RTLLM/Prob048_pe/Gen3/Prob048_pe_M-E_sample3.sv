module pe (
    input wire clk,
    input wire rst,
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] c
);

    reg [63:0] accumulator;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            accumulator <= 64'd0;
        end else begin
            accumulator <= accumulator + (a * b);
        end
    end

    assign c = accumulator[31:0];

endmodule