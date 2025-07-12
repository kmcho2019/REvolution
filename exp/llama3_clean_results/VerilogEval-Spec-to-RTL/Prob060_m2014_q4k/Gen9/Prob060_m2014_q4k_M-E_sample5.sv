// Ring Counter Module
module RingCounter(
    input clk,
    input resetn,
    output reg [1:0] count
);

always @(posedge clk) begin
    if (!resetn) begin
        count <= 2'b00;
    end else begin
        count <= (count == 2'b11) ? 2'b00 : count + 1'b1;
    end
end

endmodule

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

// Demultiplexer Module
module Demux(
    input [1:0] sel,
    input in,
    output reg [3:0] out
);

always @(*) begin
    case (sel)
        2'b00: out = {in, out[3:1]};
        2'b01: out = {out[0], in, out[3:2]};
        2'b10: out = {out[0:1], in, out[3]};
        2'b11: out = {out[0:2], in};
        default: out = 4'b0000;
    endcase
end

endmodule

// TopModule with Shift Register using Ring Counter
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [1:0] count;
reg [3:0] q;

RingCounter u_ring_counter(
    .clk(clk),
    .resetn(resetn),
    .count(count)
);

Demux u_demux(
    .sel(count),
    .in(in),
    .out(q)
);

always @(posedge clk) begin
    if (!resetn) begin
        out <= 1'b0;
    end else begin
        out <= q[3];
    end
end

endmodule