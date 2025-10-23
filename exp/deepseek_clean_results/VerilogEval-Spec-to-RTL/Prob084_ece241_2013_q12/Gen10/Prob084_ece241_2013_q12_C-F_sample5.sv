module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (enable) begin
            Q <= {Q[6:0], S};  // Efficient shift operation
        end
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output reg out
);
    always @(*) begin
        out = data[sel];  // Optimal mux implementation
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
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};  // Combined select bus

    ShiftRegister8bit sr_inst (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    Mux8to1 mux_inst (
        .data(Q),
        .sel(sel),
        .out(Z)
    );
endmodule