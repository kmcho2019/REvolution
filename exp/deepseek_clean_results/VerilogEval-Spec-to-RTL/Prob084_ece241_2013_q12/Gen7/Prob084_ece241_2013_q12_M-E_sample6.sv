module CircularShiftRegister (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Circular shift with new bit insertion
        end
    end
endmodule

module HierarchicalMux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    // First level of muxes (4x 2:1)
    wire [3:0] stage1;
    assign stage1[0] = sel[2] ? data[4] : data[0];
    assign stage1[1] = sel[2] ? data[5] : data[1];
    assign stage1[2] = sel[2] ? data[6] : data[2];
    assign stage1[3] = sel[2] ? data[7] : data[3];

    // Second level of muxes (2x 2:1)
    wire [1:0] stage2;
    assign stage2[0] = sel[1] ? stage1[2] : stage1[0];
    assign stage2[1] = sel[1] ? stage1[3] : stage1[1];

    // Final level mux (1x 2:1)
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

    CircularShiftRegister csr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    HierarchicalMux8to1 hmux_inst (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule