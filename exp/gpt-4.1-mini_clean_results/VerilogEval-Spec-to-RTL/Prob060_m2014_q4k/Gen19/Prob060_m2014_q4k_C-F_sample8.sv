module ShiftReg #(
    parameter WIDTH = 4
) (
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out
);
    reg [WIDTH-1:0] shift_reg;

    // Individual stage outputs for internal observability/debugging
    wire [WIDTH-1:0] stage;

    // Shift register implementation with synchronous active-low reset
    always @(posedge clk) begin
        if (~resetn)
            shift_reg <= {WIDTH{1'b0}};
        else
            shift_reg <= {shift_reg[WIDTH-2:0], in};
    end

    // Assign each stage to a wire for modular clarity
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : stage_assign
            assign stage[i] = shift_reg[i];
        end
    endgenerate

    assign out = stage[WIDTH-1];
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