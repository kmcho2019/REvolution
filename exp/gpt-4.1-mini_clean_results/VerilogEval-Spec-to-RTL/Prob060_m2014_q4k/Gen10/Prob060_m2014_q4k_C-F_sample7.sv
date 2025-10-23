module ShiftReg #(
    parameter WIDTH = 4
) (
    input  wire               clk,
    input  wire               resetn,
    input  wire               in,
    output wire               out
);
    reg [WIDTH-1:0] shift_reg;

    integer i;

    always @(posedge clk) begin
        if (~resetn) begin
            shift_reg <= {WIDTH{1'b0}};
        end else begin
            // Shift operation: move bits right, load new input at LSB
            shift_reg <= {shift_reg[WIDTH-2:0], in};
        end
    end

    assign out = shift_reg[WIDTH-1];
endmodule

module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);
    ShiftReg #(.WIDTH(4)) shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out)
    );
endmodule