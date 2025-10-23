// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (!resetn) begin
        q <= 1'b0;
    end else begin
        q <= d;
    end
end

endmodule

// 4-to-1 Multiplexer Module
module MUX4(
    input [1:0] sel,
    input a, b, c, d,
    output reg out
);

always @(sel or a or b or c or d) begin
    case (sel)
        2'b00: out <= a;
        2'b01: out <= b;
        2'b10: out <= c;
        2'b11: out <= d;
    endcase
end

endmodule

// Multiplexer-Based Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;
reg [1:0] sel;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000;
        sel <= 2'b00;
    end else begin
        q[0] <= in;
        q[1] <= q[0];
        q[2] <= q[1];
        q[3] <= q[2];
    end
end

MUX4 mux0 (.sel(sel), .a(in), .b(q[0]), .c(q[1]), .d(q[2]), .out(q[0]));
MUX4 mux1 (.sel(sel), .a(q[0]), .b(q[1]), .c(q[2]), .d(q[3]), .out(q[1]));
MUX4 mux2 (.sel(sel), .a(q[1]), .b(q[2]), .c(q[3]), .d(in), .out(q[2]));
MUX4 mux3 (.sel(sel), .a(q[2]), .b(q[3]), .c(in), .d(q[0]), .out(q[3]));

assign out = q[3];

endmodule