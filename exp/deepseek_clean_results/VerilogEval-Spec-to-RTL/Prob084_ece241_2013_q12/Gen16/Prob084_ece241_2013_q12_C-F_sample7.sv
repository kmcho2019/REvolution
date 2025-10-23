module ParamShiftRegister #(parameter WIDTH = 8) (
    input clk,
    input enable,
    input S,
    output reg [WIDTH-1:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[WIDTH-2:0], S};  // MSB first shift
        end
    end
endmodule

module BalancedMux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    // Level 1: 4x 2:1 muxes
    wire [3:0] l1_out;
    assign l1_out[0] = sel[0] ? data[1] : data[0];
    assign l1_out[1] = sel[0] ? data[3] : data[2];
    assign l1_out[2] = sel[0] ? data[5] : data[4];
    assign l1_out[3] = sel[0] ? data[7] : data[6];
    
    // Level 2: 2x 2:1 muxes
    wire [1:0] l2_out;
    assign l2_out[0] = sel[1] ? l1_out[1] : l1_out[0];
    assign l2_out[1] = sel[1] ? l1_out[3] : l1_out[2];
    
    // Level 3: Final 2:1 mux
    assign out = sel[2] ? l2_out[1] : l2_out[0];
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
    parameter MEM_SIZE = 8;
    wire [MEM_SIZE-1:0] Q;
    wire [2:0] sel = {A, B, C};

    ParamShiftRegister #(.WIDTH(MEM_SIZE)) sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    BalancedMux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule