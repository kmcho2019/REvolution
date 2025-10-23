// D Flip-flop with enable
module DFF (
    input clk,
    input en,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (en) q <= d;
    end
endmodule

// Shift register using explicit DFF instances
module ShiftRegister8bit (
    input clk,
    input enable,
    input S,
    output [7:0] Q
);
    wire [7:0] d_in;
    
    // Chain the flip-flops
    assign d_in = {Q[6:0], S};
    
    // Instantiate 8 DFFs
    DFF ff0 (.clk(clk), .en(enable), .d(d_in[0]), .q(Q[0]));
    DFF ff1 (.clk(clk), .en(enable), .d(d_in[1]), .q(Q[1]));
    DFF ff2 (.clk(clk), .en(enable), .d(d_in[2]), .q(Q[2]));
    DFF ff3 (.clk(clk), .en(enable), .d(d_in[3]), .q(Q[3]));
    DFF ff4 (.clk(clk), .en(enable), .d(d_in[4]), .q(Q[4]));
    DFF ff5 (.clk(clk), .en(enable), .d(d_in[5]), .q(Q[5]));
    DFF ff6 (.clk(clk), .en(enable), .d(d_in[6]), .q(Q[6]));
    DFF ff7 (.clk(clk), .en(enable), .d(d_in[7]), .q(Q[7]));
endmodule

// 8:1 Mux using case statement
module Mux8to1 (
    input [7:0] data,
    input [2:0] sel,
    output reg out
);
    always @(*) begin
        case (sel)
            3'b000: out = data[0];
            3'b001: out = data[1];
            3'b010: out = data[2];
            3'b011: out = data[3];
            3'b100: out = data[4];
            3'b101: out = data[5];
            3'b110: out = data[6];
            3'b111: out = data[7];
        endcase
    end
endmodule

// Top module remains the same interface
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