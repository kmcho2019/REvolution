module ShiftReg #(
    parameter WIDTH = 4
) (
    input  clk,
    input  resetn,
    input  in,
    output out
);
    reg [WIDTH-1:0] shift_reg;
    reg prev_in;

    wire enable = (~resetn) | (in != prev_in);

    always @(posedge clk) begin
        if (~resetn) begin
            shift_reg <= {WIDTH{1'b0}};
            prev_in <= 1'b0;
        end else if (enable) begin
            shift_reg <= (shift_reg << 1) | in;
            prev_in <= in;
        end
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