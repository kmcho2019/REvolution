module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    reg [7:0] reg_data;
    wire [7:0] next_data = enable ? {reg_data[6:0], S} : reg_data;

    always @(posedge clk) begin
        reg_data <= next_data;
    end

    assign Q = reg_data;
endmodule

module BinaryTreeMux (
    input [7:0] data,
    input [2:0] sel,
    output out
);
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

    CircularShiftRegister csr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    BinaryTreeMux mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule