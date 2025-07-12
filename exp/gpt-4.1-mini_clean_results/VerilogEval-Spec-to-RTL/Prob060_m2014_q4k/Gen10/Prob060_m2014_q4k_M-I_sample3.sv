module ShiftReg_SRL (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    // Parameter for length of shift register
    localparam WIDTH = 4;

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
    input  clk,
    input  resetn,
    input  in,
    output out
);
    ShiftReg_SRL shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out)
    );
endmodule