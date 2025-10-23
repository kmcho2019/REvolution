module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // MSB first shift
        end
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output reg out
);
    always @(*) begin
        out = data[sel];  // Direct indexing for best performance
    end
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
    parameter WIDTH = 8;
    
    wire [WIDTH-1:0] Q;
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