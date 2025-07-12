module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assign for one combinational output
    assign out_assign = a ^ b;

    // Combinational always block for the other combinational output
    always @(*) begin
        out_always_comb = a ^ b;
    end

    // Sequential logic: register the XOR result at clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule