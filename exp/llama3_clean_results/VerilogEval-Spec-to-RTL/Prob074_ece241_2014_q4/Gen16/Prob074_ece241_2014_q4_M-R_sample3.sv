module TopModule(
    input clk,
    input x,
    output z
);
    reg [2:0] q = 3'b000; // Three D flip-flops

    always @(posedge clk) begin
        q[0] <= x ^ q[0]; // XOR gate and D flip-flop
        q[1] <= x & ~q[1]; // AND gate and D flip-flop
        q[2] <= x | ~q[2]; // OR gate and D flip-flop
    end

    assign z = ~(q[0] | q[1] | q[2]); // NOR gate for output 'z'
endmodule