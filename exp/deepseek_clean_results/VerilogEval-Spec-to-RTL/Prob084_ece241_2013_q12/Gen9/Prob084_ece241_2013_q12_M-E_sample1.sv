module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] shift_reg;
    wire gated_clk = clk & enable;  // Simple clock gating

    always @(posedge gated_clk) begin
        shift_reg <= {shift_reg[6:0], S};  // Still linear shift but with gated clock
    end

    assign Q = shift_reg;
endmodule

module Mux4to1 (
    input [3:0] data,
    input [1:0] sel,
    output out
);
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
    wire mux1_out, mux2_out;

    CircularShiftRegister csr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    // First level: Two 4:1 muxes
    Mux4to1 mux1 (
        .data(Q[3:0]),
        .sel({B, C}),
        .out(mux1_out)
    );

    Mux4to1 mux2 (
        .data(Q[7:4]),
        .sel({B, C}),
        .out(mux2_out)
    );

    // Second level: 2:1 mux
    assign Z = A ? mux2_out : mux1_out;
endmodule