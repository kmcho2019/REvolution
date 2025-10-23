module TopModule #(
    parameter WIDTH = 100
) (
    input  clk,
    input  rst_n,
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= '0;
        end else if (in != '0) begin
            shift_reg <= {shift_reg[WIDTH-2:0], in[WIDTH-1]};
        end
    end

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            assign out[i] = shift_reg[WIDTH - 1 - i];
        end
    endgenerate

endmodule