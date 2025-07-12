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

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

DFF dff0(clk, resetn, in, out);
DFF dff1(clk, resetn, out, );
wire q2;
DFF dff2(clk, resetn, q2, );
DFF dff3(clk, resetn, out, q2);

endmodule