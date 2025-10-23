module TopModule #(
    parameter LENGTH = 4
) (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [LENGTH-1:0] shift_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            shift_reg <= {LENGTH{1'b0}};
        end else begin
            shift_reg <= {shift_reg[LENGTH-2:0], in};
        end
    end

    assign out = shift_reg[LENGTH-1];

endmodule