module TopModule(
    input  clk,
    input  a,
    input  b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

    // Continuous assignment XOR
    assign out_assign = a ^ b;

    // Combinational always block with internal reg assigned on any input change
    always @* begin
        out_always_comb = a ^ b;
    end

    // Sequential always block: register XOR result at positive clock edge
    always @(posedge clk) begin
        out_always_ff <= a ^ b;
    end

endmodule