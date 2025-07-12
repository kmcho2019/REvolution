module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // All combinational logic using continuous assignments
    assign out_assign = a ^ b;
    assign out_always_comb = a ^ b;

    // Single always block for sequential logic
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule