module TopModule(clk, x, z);
    input clk, x;
    output z;
    reg [2:0] q;
    wire [2:0] d;

    // Gates
    assign d[0] = x ^ q[0]; // XOR gate
    assign d[1] = x & ~q[1]; // AND gate
    assign d[2] = x | ~q[2]; // OR gate

    // D flip-flops
    always @(posedge clk)
    begin
        q <= d;
    end

    // NOR gate
    assign z = ~(d[0] | d[1] | d[2]);

    // Initial state
    initial
    begin
        q <= 3'b000;
    end

endmodule