module TopModule (
    input  clk,
    input  x,
    output z
);

    // 3-bit register: bit0 = XOR flip-flop output
    //                bit1 = AND flip-flop output
    //                bit2 = OR flip-flop output
    reg [2:0] ff_reg;

    // Initial block for synthesis-friendly initialization of flip-flops to zero
    initial begin
        ff_reg = 3'b000;
    end

    always @(posedge clk) begin
        ff_reg[0] <= x ^ ff_reg[0];       // XOR gate input: x and previous XOR output
        ff_reg[1] <= x & ~ff_reg[1];      // AND gate input: x and complement of previous AND output
        ff_reg[2] <= x | ~ff_reg[2];      // OR gate input: x and complement of previous OR output
    end

    // Output z is NOR of all three flip-flop outputs
    assign z = (ff_reg == 3'b000);

endmodule