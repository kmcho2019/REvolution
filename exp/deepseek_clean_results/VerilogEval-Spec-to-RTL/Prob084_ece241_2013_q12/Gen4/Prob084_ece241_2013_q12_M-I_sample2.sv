`default_nettype none

module ShiftRegister8bit (
    input  wire clk,
    input  wire enable,
    input  wire S,
    output reg  [7:0] Q
);
    wire gated_clk = clk & enable;
    
    always_ff @(posedge gated_clk) begin
        Q <= {Q[6:0], S};  // Shift left, MSB first
    end
endmodule

module Mux8to1 (
    input  wire [7:0] data,
    input  wire [2:0] sel,
    output wire out
);
    // One-hot implementation for better power with locality
    wire [7:0] sel_decoded = (sel == 3'b000) ? 8'b00000001 :
                            (sel == 3'b001) ? 8'b00000010 :
                            (sel == 3'b010) ? 8'b00000100 :
                            (sel == 3'b011) ? 8'b00001000 :
                            (sel == 3'b100) ? 8'b00010000 :
                            (sel == 3'b101) ? 8'b00100000 :
                            (sel == 3'b110) ? 8'b01000000 :
                            8'b10000000;
    
    assign out = |(data & sel_decoded);
endmodule

module TopModule (
    input  wire clk,
    input  wire enable,
    input  wire S,
    input  wire A,
    input  wire B,
    input  wire C,
    output wire Z
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