module TopModule (
    input  clk,
    input  x,
    output z
);

    // Internal power-on reset signal (active high for one clock cycle)
    reg reset_done = 1'b0; // 0 means reset asserted, 1 means released

    // 3-bit register: bit0 = xor ff, bit1 = and ff, bit2 = or ff
    reg [2:0] ff_reg;

    always @(posedge clk) begin
        if (~reset_done) begin
            ff_reg <= 3'b000;       // initialize all flip-flops to zero
            reset_done <= 1'b1;    // release reset after first clock
        end else begin
            ff_reg[0] <= x ^ ff_reg[0];       // XOR gate DFF
            ff_reg[1] <= x & ~ff_reg[1];      // AND gate DFF
            ff_reg[2] <= x | ~ff_reg[2];      // OR gate DFF
        end
    end

    // Output z is NOR of all three flip-flop outputs
    assign z = (ff_reg == 3'b000);

endmodule