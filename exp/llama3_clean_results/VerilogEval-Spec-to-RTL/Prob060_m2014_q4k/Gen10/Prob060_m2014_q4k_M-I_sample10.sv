// Improved D Flip-Flop Module with Active-Low Synchronous Reset
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

// TopModule with Shift Register and Potential for Clock Gating
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

// Given the simple nature of this design, direct instantiation is maintained
// for clarity and minimalism. However, for more complex designs, consider
// using generate statements or arrays for DFFs to improve readability and
// maintainability.

wire q0, q1, q2;

DFF dff0(clk, resetn, in, q0);
DFF dff1(clk, resetn, q0, q1);
DFF dff2(clk, resetn, q1, q2);
DFF dff3(clk, resetn, q2, out);

// For future improvements, consider adding clock gating logic here if the
// design allows for it, to reduce power consumption during periods of inactivity.

endmodule