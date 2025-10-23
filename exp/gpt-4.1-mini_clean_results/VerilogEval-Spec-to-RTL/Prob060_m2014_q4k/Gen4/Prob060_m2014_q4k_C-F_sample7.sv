module ShiftReg #(
    parameter WIDTH = 4
) (
    input clk,
    input resetn,
    input in,
    output out
);

    reg [WIDTH-1:0] shift_reg;

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= {WIDTH{1'b0}};
        else
            shift_reg <= {shift_reg[WIDTH-2:0], in};
    end

    assign out = shift_reg[WIDTH-1];

endmodule

module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);
    ShiftReg #(.WIDTH(4)) shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out)
    );
endmodule