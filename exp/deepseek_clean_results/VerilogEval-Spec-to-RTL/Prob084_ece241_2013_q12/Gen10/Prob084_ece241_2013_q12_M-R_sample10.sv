module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    // Clocked assignment with enable control
    always @(posedge clk) begin
        Q <= enable ? {Q[6:0], S} : Q;
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    // Continuous assignment for mux
    assign out = data[sel];
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