module DFF (
    input wire clk,
    input wire resetn,
    input wire d,
    output reg q
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
    input  wire clk,
    input  wire resetn,
    input  wire in,
    output wire out,
    output wire [WIDTH-1:0] stage  // expose internal stage outputs for debug/trace
);

    // Internal wires for connecting DFF chain
    wire [WIDTH-1:0] q;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : dff_chain
            if (i == 0) begin
                DFF dff_inst (
                    .clk(clk),
                    .resetn(resetn),
                    .d(in),
                    .q(q[i])
                );
            end else begin
                DFF dff_inst (
                    .clk(clk),
                    .resetn(resetn),
                    .d(q[i-1]),
                    .q(q[i])
                );
            end
            assign stage[i] = q[i];
        end
    endgenerate

    assign out = q[WIDTH-1];

endmodule


module TopModule (
    input wire clk,
    input wire resetn,
    input wire in,
    output wire out
);
    // Internal wire to connect stage outputs, left unconnected in TopModule
    wire [3:0] stage_unused;

    ShiftReg #(.WIDTH(4)) shift_reg_inst (
        .clk(clk),
        .resetn(resetn),
        .in(in),
        .out(out),
        .stage(stage_unused)
    );
endmodule