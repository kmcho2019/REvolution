`default_nettype none

module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_ff
);

    // Most efficient combinational implementation
    assign out_assign = a ^ b;

    // Sequential implementation with proper edge-triggered behavior
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule