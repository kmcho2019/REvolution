module TopModule (
    input  clk,
    input  x,
    output z
);

    // 3-bit register to hold the flip-flop outputs, initialized to zero
    reg [2:0] ff_reg = 3'b000;

    always @(posedge clk) begin
        ff_reg[0] <= x ^ ff_reg[0];      // XOR gate DFF
        ff_reg[1] <= x & ~ff_reg[1];    // AND gate DFF with complemented input
        ff_reg[2] <= x | ~ff_reg[2];    // OR gate DFF with complemented input
    end

    // Output z is the NOR of all three flip-flop outputs
    assign z = ~(ff_reg[0] | ff_reg[1] | ff_reg[2]);

endmodule