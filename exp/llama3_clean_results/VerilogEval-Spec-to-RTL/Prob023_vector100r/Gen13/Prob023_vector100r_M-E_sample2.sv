module TopModule #(
    parameter INPUT_SIZE = 100
) (
    input  [INPUT_SIZE-1:0] in,
    output [INPUT_SIZE-1:0] out
);

    reg [INPUT_SIZE-1:0] shift_reg;
    reg [$clog2(INPUT_SIZE)-1:0] counter;

    always @(posedge in) begin
        if (counter == 0) begin
            shift_reg <= in;
            counter <= INPUT_SIZE - 1;
        end else begin
            shift_reg <= {shift_reg[INPUT_SIZE-2:0], in[INPUT_SIZE-1]};
            counter <= counter - 1;
        end
    end

    assign out = shift_reg;

endmodule