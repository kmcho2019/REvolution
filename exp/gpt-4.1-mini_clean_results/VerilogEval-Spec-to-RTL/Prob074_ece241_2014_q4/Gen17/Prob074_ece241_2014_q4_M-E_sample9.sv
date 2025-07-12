module TopModule (
    input  clk,
    input  x,
    output z
);

    reg [2:0] state;  // Bits: 0->XOR ff, 1->AND ff, 2->OR ff

    // Internal synchronous reset logic: one-cycle reset at start
    reg reset_n = 1'b0;
    reg reset_init = 1'b0;
    always @(posedge clk) begin
        if (!reset_init) begin
            reset_n <= 1'b0;     // hold reset low first clock
            reset_init <= 1'b1;
        end else begin
            reset_n <= 1'b1;     // then release reset
        end
    end

    wire [2:0] d_in;
    // Compute D inputs for each flip-flop bit
    // state[0] = XOR ff output
    assign d_in[0] = x ^ state[0];
    // state[1] = AND ff output
    assign d_in[1] = x & ~state[1];
    // state[2] = OR ff output
    assign d_in[2] = x | ~state[2];

    always @(posedge clk) begin
        if (!reset_n)
            state <= 3'b000;   // synchronous reset sets all flip-flops to 0
        else
            state <= d_in;
    end

    // z is NOR of all three flip-flop bits
    assign z = ~(state[0] | state[1] | state[2]);

endmodule