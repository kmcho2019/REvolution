module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);

reg [7:0] Q;

always @(posedge clk) begin
    if (enable) begin
        Q[7:1] <= Q[6:0];
        Q[0] <= S;
    end
end

mux8to1 mux_inst(
    .I0(Q[0]),
    .I1(Q[1]),
    .I2(Q[2]),
    .I3(Q[3]),
    .I4(Q[4]),
    .I5(Q[5]),
    .I6(Q[6]),
    .I7(Q[7]),
    .S({A, B, C}),
    .Y(Z)
);

endmodule

module mux8to1(
    input I0,
    input I1,
    input I2,
    input I3,
    input I4,
    input I5,
    input I6,
    input I7,
    input [2:0] S,
    output Y
);

reg Y;

always @(I0, I1, I2, I3, I4, I5, I6, I7, S) begin
    case (S)
        3'b000: Y = I0;
        3'b001: Y = I1;
        3'b010: Y = I2;
        3'b011: Y = I3;
        3'b100: Y = I4;
        3'b101: Y = I5;
        3'b110: Y = I6;
        3'b111: Y = I7;
        default: Y = 1'bx;
    endcase
end

endmodule