module TopModule (
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // assign statement for combinational XOR
    assign out_assign = a ^ b;

    // combinational always block for XOR
    always @* begin
        out_always_comb = a ^ b;
    end

    // clocked always block for registered XOR output
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule