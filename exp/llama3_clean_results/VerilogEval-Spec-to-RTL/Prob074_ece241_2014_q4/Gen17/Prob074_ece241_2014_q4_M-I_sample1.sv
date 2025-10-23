module TopModule(
    input clk,
    input x,
    output z
);
    reg [2:0] q = 3'b000; // Three D flip-flops

    wire xor_out, and_out, or_out; // Intermediate signals for gate outputs

    // Combinational logic for gate operations
    assign xor_out = x ^ q[0];
    assign and_out = x & ~q[1];
    assign or_out = x | ~q[2];

    // Sequential logic for D flip-flops
    always @(posedge clk) begin
        q[0] <= xor_out;
        q[1] <= and_out;
        q[2] <= or_out;
    end

    // NOR gate for output 'z'
    assign z = ~(q[0] | q[1] | q[2]);
endmodule