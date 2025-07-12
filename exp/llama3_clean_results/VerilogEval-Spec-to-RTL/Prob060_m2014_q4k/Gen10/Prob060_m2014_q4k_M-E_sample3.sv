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

// Ring Counter-Based Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q;

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000;
    end else begin
        q[0] <= in;
        q[1] <= q[0];
        q[2] <= q[1];
        q[3] <= q[2];
    end
end

assign out = q[3];

endmodule