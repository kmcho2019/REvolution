module ShiftReg #(
    parameter WIDTH = 4
) (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    reg [WIDTH-1:0] shift_reg;
    wire ce;

    // Clock enable asserted only if the new input differs from the LSB of the register,
    // indicating a state change on shift.
    assign ce = (shift_reg[0] != in);

    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= {WIDTH{1'b0}};
        else if (ce)
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        // else hold current state, no toggling
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