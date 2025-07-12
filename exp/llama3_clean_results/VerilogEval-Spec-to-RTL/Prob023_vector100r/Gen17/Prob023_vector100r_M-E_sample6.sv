module TopModule #(
    parameter WIDTH = 100
) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge in) begin
        shift_reg[0] <= in[WIDTH-1];
        for (int i = 1; i < WIDTH; i++) begin
            shift_reg[i] <= in[WIDTH-1-i];
        end
    end

    assign out = shift_reg;

endmodule