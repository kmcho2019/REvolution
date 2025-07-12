module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Efficient vector shift with enable
        end
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output reg out
);
    always @(*) begin
        out = data[sel];  // Most efficient mux implementation
    end
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

    ShiftRegister8bit shift_reg (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    Mux8to1 output_mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule