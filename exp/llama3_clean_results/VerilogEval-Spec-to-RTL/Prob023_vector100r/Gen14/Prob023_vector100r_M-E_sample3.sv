module TopModule #(
    parameter INPUT_SIZE = 100
) (
    input               clk,
    input               rst_n,
    input  [INPUT_SIZE-1:0] in,
    output [INPUT_SIZE-1:0] out
);

    reg [INPUT_SIZE-1:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            shift_reg <= {INPUT_SIZE{1'b0}};
        end else begin
            shift_reg <= {in[0], shift_reg[INPUT_SIZE-1:1]};
        end
    end

    assign out = shift_reg;

endmodule