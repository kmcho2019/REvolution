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
    output reg out
);
    // Balanced binary tree implementation
    always @(*) begin
        case (sel)
            3'b000: out = data[0];
            3'b001: out = data[1];
            3'b010: out = data[2];
            3'b011: out = data[3];
            3'b100: out = data[4];
            3'b101: out = data[5];
            3'b110: out = data[6];
            3'b111: out = data[7];
            default: out = 1'bx; // Power optimization
        endcase
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};
    wire mux_out;

    ShiftRegister8bit sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    Mux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(mux_out)
    );

    // Registered output for better timing
    always @(posedge clk) begin
        Z <= mux_out;
    end
endmodule