module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    wire gated_clk;
    
    assign gated_clk = clk & enable;
    
    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};
    end
endmodule

module Mux4to1 (
    input [3:0] data,
    input [1:0] sel,
    output reg out
);
    always @(*) begin
        case (sel)
            2'b00: out = data[0];
            2'b01: out = data[1];
            2'b10: out = data[2];
            2'b11: out = data[3];
        endcase
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output out
);
    wire mux0_out, mux1_out;
    
    Mux4to1 mux0 (
        .data(data[3:0]),
        .sel(sel[1:0]),
        .out(mux0_out)
    );
    
    Mux4to1 mux1 (
        .data(data[7:4]),
        .sel(sel[1:0]),
        .out(mux1_out)
    );
    
    assign out = sel[2] ? mux1_out : mux0_out;
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
    
    ShiftRegister8bit sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );
    
    Mux8to1 mux (
        .data(Q),
        .sel({A, B, C}),
        .out(Z)
    );
endmodule