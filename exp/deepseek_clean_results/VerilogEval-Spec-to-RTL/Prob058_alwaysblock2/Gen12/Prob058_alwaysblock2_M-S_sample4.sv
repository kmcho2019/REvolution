module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_ff
);

    // Continuous assignment (simplest combinational implementation)
    assign out_assign = a ^ b;

    // Sequential implementation (only keep this special case)
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule