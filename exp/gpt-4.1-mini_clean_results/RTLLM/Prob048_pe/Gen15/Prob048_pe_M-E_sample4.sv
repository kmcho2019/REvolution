module pe (
    input             clk,
    input             rst,
    input      [31:0] a,
    input      [31:0] b,
    output reg [31:0] c
);

    reg [63:0] accumulator;

    always @(posedge clk) begin
        if (rst) begin
            accumulator <= 64'd0;
            c <= 32'd0;
        end else begin
            accumulator <= accumulator + (a * b);
            c <= accumulator[31:0];
        end
    end

endmodule