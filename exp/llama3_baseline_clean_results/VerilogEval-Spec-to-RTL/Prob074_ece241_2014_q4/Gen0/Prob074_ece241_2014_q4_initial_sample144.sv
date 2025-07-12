module TopModule(clk, x, z);
    input clk;
    input x;
    output z;

    reg [2:0] q; // output of the three D flip-flops
    reg [2:0] d; // input of the three D flip-flops

    // XOR gate
    assign d[0] = x ^ q[0];

    // AND gate
    assign d[1] = x & ~q[1];

    // OR gate
    assign d[2] = x | ~q[2];

    // three-input NOR gate
    assign z = ~(d[0] | d[1] | d[2]);

    // D flip-flop
    always @(posedge clk) begin
        q <= d;
    end

    // initial value of the D flip-flops
    initial begin
        q = 3'b000;
    end
endmodule