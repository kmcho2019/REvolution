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

module Mux4to1 (
    input [3:0] data,
    input [1:0] sel,
    output out
);
    assign out = data[sel];
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire out_low, out_high;
    
    Mux4to1 mux_low (
        .data(data[3:0]),
        .sel(sel[1:0]),
        .out(out_low)
    );
    
    Mux4to1 mux_high (
        .data(data[7:4]),
        .sel(sel[1:0]),
        .out(out_high)
    );
    
    assign out = sel[2] ? out_high : out_low;
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