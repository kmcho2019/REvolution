module TopModule #(
    parameter WIDTH = 4
) (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {WIDTH{1'b0}};
        end
        else begin
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        end
    end

    assign out = shift_reg[WIDTH-1];

endmodule