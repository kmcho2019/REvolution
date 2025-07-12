// D Flip-Flop Module with Active-Low Synchronous Reset
module DFF(
    input clk,
    input resetn,
    input d,
    output q
);

reg q_reg;
assign q = q_reg;

always @(posedge clk) begin
    if (!resetn) begin
        q_reg <= 1'b0;
    end else begin
        q_reg <= d;
    end
end

endmodule

// TopModule with Shift Register
module TopModule(
    input clk,
    input resetn,
    input in,
    output out
);

wire q0, q1, q2, q3;

DFF dff0(clk, resetn, in, q0);
DFF dff1(clk, resetn, q0, q1);
DFF dff2(clk, resetn, q1, q2);
DFF dff3(clk, resetn, q2, q3);

assign out = q3;

endmodule