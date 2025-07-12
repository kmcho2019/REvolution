module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] shift_reg;
    wire gated_clk;

    // Clock gating for power optimization
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
    // Binary tree mux structure for better timing
    wire [1:0] stage1;
    
    assign stage1[0] = sel[2] ? data[sel[1:0]+4] : data[sel[1:0]];
    assign out = stage1[0];
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