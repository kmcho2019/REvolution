module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    input [7:0] parallel_in,
    input load,
    output [7:0] Q
);
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (enable) begin
            if (load)
                shift_reg <= parallel_in;
            else
                shift_reg <= {shift_reg[6:0], S};
        end
    end

    assign Q = shift_reg;
endmodule

module Mux2to1 (
    input a,
    input b,
    input sel,
    output out
);
    assign out = sel ? b : a;
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire [3:0] stage1;
    wire [1:0] stage2;
    
    // First level of muxes
    Mux2to1 mux0(.a(data[0]), .b(data[1]), .sel(sel[0]), .out(stage1[0]));
    Mux2to1 mux1(.a(data[2]), .b(data[3]), .sel(sel[0]), .out(stage1[1]));
    Mux2to1 mux2(.a(data[4]), .b(data[5]), .sel(sel[0]), .out(stage1[2]));
    Mux2to1 mux3(.a(data[6]), .b(data[7]), .sel(sel[0]), .out(stage1[3]));
    
    // Second level of muxes
    Mux2to1 mux4(.a(stage1[0]), .b(stage1[1]), .sel(sel[1]), .out(stage2[0]));
    Mux2to1 mux5(.a(stage1[2]), .b(stage1[3]), .sel(sel[1]), .out(stage2[1]));
    
    // Final mux
    Mux2to1 mux6(.a(stage2[0]), .b(stage2[1]), .sel(sel[2]), .out(out));
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

    // Tie parallel_in and load to 0 since we're not using parallel load
    ShiftRegister8bit sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .parallel_in(8'b0),
        .load(1'b0),
        .Q(Q)
    );

    Mux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule