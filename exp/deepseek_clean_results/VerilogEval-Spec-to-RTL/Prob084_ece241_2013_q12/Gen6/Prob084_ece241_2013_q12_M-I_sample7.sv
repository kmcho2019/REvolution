module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output reg [7:0] Q
);
    // Clock gating implementation
    wire gated_clk;
    assign gated_clk = clk & enable;

    always @(posedge gated_clk) begin
        Q <= {Q[6:0], S};  // Shift left, MSB first
    end
endmodule

module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output reg out  // Registered output for better timing
);
    always @(*) begin
        out = data[sel];  // Most efficient mux implementation
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z  // Registered output
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};
    wire mux_out;

    ShiftRegister8bit sr (
        .clk(clk),
        .enable(enable),
        .S(S),
        .Q(Q)
    );

    Mux8to1 mux (
        .data(Q),
        .sel(sel),
        .out(mux_out)
    );

    // Optional output register for better timing in larger designs
    always @(posedge clk) begin
        Z <= mux_out;
    end
endmodule