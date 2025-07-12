module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    wire gated_clk;
    assign gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};  // Standard shift when enabled
    end
endmodule

module HierarchicalMux (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire [1:0] stage1;

    // First level: 4x 2:1 muxes
    assign stage1[0] = sel[0] ? data[1] : data[0];
    assign stage1[1] = sel[0] ? data[3] : data[2];
    
    // Second level: 2:1 mux
    wire stage2 = sel[1] ? stage1[1] : stage1[0];
    
    // Final level: 2:1 mux
    assign out = sel[2] ? data[7:4][sel[1:0]] : stage2;
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
    wire [7:0] reg_out;
    wire [2:0] select = {A, B, C};

    CircularShiftRegister csr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(reg_out)
    );

    HierarchicalMux hmux (
        .data(reg_out),
        .sel(select),
        .out(Z)
    );
endmodule