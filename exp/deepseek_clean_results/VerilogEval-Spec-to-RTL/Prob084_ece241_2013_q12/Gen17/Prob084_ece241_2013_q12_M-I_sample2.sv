module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] shift_reg;
    wire gated_clk = clk & enable;  // Clock gating

    always @(posedge gated_clk) begin
        shift_reg <= {shift_reg[6:0], S};
    end

    assign Q = shift_reg;
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    // Binary tree implementation
    wire [3:0] stage1 = sel[2] ? data[7:4] : data[3:0];
    wire [1:0] stage2 = sel[1] ? stage1[3:2] : stage1[1:0];
    assign out = sel[0] ? stage2[1] : stage2[0];
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
    wire [7:0] Q;
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