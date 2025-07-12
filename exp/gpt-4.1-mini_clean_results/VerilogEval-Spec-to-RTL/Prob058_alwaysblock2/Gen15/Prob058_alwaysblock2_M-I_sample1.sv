module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assign statement for combinational XOR output
    assign out_assign = a ^ b;

    // Combinational always block for out_always_comb
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential logic: register XOR result on clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule