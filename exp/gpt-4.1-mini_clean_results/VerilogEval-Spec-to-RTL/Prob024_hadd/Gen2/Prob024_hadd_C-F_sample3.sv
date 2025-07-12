module TopModule(
    input wire a,
    input wire b,
    output wire sum,
    output wire cout
);
    // Use an always_comb block with outputs declared as wires.
    // This is legal in SystemVerilog and clearly conveys combinational logic.
    // The outputs are driven by the always_comb block, ensuring no latch inference.
    // sum = a XOR b; cout = a AND b.
    always_comb begin
        sum = a ^ b;
        cout = a & b;
    end
endmodule