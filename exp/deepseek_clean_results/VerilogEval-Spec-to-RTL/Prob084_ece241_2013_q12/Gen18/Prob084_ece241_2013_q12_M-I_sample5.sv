module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] shift_reg;
    wire gated_clk;

    // Clock gating cell
    assign gated_clk = clk & enable;

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
    // Binary tree implementation for better area and timing
    wire [1:0] stage1;
    wire stage2;

    assign stage1[0] = sel[0] ? data[1] : data[0];
    assign stage1[1] = sel[0] ? data[3] : data[2];
    assign stage2 = sel[1] ? (sel[0] ? data[7] : data[6]) : (sel[0] ? data[5] : data[4]);
    assign out = sel[2] ? stage2 : (sel[1] ? stage1[1] : stage1[0]);
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