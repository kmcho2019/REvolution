module TopModule (
    input  wire clk,
    input  wire a,
    input  wire b,
    output wire out_assign,
    output wire out_always_comb,
    output reg  out_always_ff
);

    // Original continuous assignment implementation
    assign out_assign = a ^ b;

    // Alternative combinational implementation using ternary operator
    assign out_always_comb = (a == b) ? 1'b0 : 1'b1;

    // Sequential implementation with XOR inside the always block
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule