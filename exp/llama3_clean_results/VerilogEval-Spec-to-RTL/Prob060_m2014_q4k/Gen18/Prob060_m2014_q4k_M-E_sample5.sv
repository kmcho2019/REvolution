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

// Ring Counter Module
module RingCounter(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] data;

always @(posedge clk) begin
    if (!resetn) begin
        data <= 4'b0000;
    end else begin
        data <= {data[2:0], in};
    end
end

assign out = data[3];

endmodule

// TopModule with Ring Counter
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

RingCounter ring_counter(clk, resetn, in, out);

endmodule