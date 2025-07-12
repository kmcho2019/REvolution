module DFF_SR (
    input  wire clk,
    input  wire resetn,  // active-low synchronous reset
    input  wire d,
    output reg  q
);
    always @(posedge clk) begin
        if (~resetn)
            q <= 1'b0;
        else
            q <= d;
    end
endmodule

module ShiftReg #(
    parameter WIDTH = 4
) (
    input  wire        clk,
    input  wire        resetn,
    input  wire        in,
    output wire        out
);
    wire [WIDTH-1:0] q;
    genvar i;

    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : gen_dffs
            if (i == 0) begin
                DFF_SR dff_inst (
                    .clk(clk),
                    .resetn(resetn),
                    .d(in),
                    .q(q[i])
                );
            end else begin
                DFF_SR dff_inst (
                    .clk(clk),
                    .resetn(resetn),
                    .d(q[i-1]),
                    .q(q[i])
                );
            end
        end
    endgenerate

    assign out = q[WIDTH-1];
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