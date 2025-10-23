module TopModule (
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Standard continuous assignment XOR
    assign out_assign = a ^ b;

    // Standard combinational always block XOR
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Novel stateful XOR implementation:
    // Toggles output when inputs differ
    always @(posedge clk) begin
        if (a ^ b) begin
            out_always_ff <= ~out_always_ff;
        end
    end

endmodule