module ShiftReg #(
    parameter WIDTH = 4
) (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    reg [WIDTH-1:0] shift_reg;
    wire shift_en;

    // Enable shift only if new input differs from current LSB (shift_reg[0])
    assign shift_en = (in != shift_reg[0]);

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= {WIDTH{1'b0}};
        else if (shift_en)
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        // else hold the value (no change)
    end

    assign out = shift_reg[WIDTH-1];
endmodule

module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    ShiftReg #(.WIDTH(4)) shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out)
    );
endmodule