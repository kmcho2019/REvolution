module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output reg out_always_comb,
    output reg out_always_ff
);

assign out_assign = a ^ b;

reg prev_clk;
always @(posedge clk or negedge clk) begin
    if (clk && !prev_clk) begin // Positive edge
        out_always_ff = a ^ b;
    end else begin
        out_always_comb = a ^ b;
    end
    prev_clk = clk;
end

initial begin
    prev_clk = 0;
end

endmodule

// Testbench
module tb_TopModule;
    reg clk, a, b;
    wire out_assign;
    reg out_always_comb;
    reg out_always_ff;

    TopModule uut (
        .clk(clk),
        .a(a),
        .b(b),
        .out_assign(out_assign),
        .out_always_comb(out_always_comb),
        .out_always_ff(out_always_ff)
    );

    initial begin
        clk = 0;
        a = 0;
        b = 0;
        #10;
        a = 1;
        #10;
        b = 1;
        #10;
        $finish;
    end

    always #5 clk = ~clk;

endmodule