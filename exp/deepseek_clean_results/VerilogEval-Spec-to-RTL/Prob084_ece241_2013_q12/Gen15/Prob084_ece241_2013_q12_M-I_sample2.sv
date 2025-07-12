module ShiftRegister8bit #(parameter WIDTH = 8) (
    input clk,
    input enable,
    input S,
    output [WIDTH-1:0] Q
);
    (* dont_touch = "true" *) reg [WIDTH-1:0] shift_reg;
    wire gated_clk;

    // Clock gating cell
    CLKGATE_X1 clk_gate (
        .CK(clk),
        .E(enable),
        .ECK(gated_clk)
    );

    always @(posedge gated_clk) begin
        shift_reg <= {shift_reg[WIDTH-2:0], S};
    end

    assign Q = shift_reg;
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    (* dont_touch = "true" *) wire [1:0] stage1 [0:3];
    (* dont_touch = "true" *) wire [1:0] stage2;

    // First stage: 4 2:1 muxes
    assign stage1[0] = sel[0] ? data[1] : data[0];
    assign stage1[1] = sel[0] ? data[3] : data[2];
    assign stage1[2] = sel[0] ? data[5] : data[4];
    assign stage1[3] = sel[0] ? data[7] : data[6];

    // Second stage: 2 2:1 muxes
    assign stage2[0] = sel[1] ? stage1[1] : stage1[0];
    assign stage2[1] = sel[1] ? stage1[3] : stage1[2];

    // Final stage: 1 2:1 mux
    assign out = sel[2] ? stage2[1] : stage2[0];
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    (* power_optimized = "true" *) wire [7:0] Q;
    wire [2:0] sel = {A, B, C};

    ShiftRegister8bit sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    Mux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule