module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_ff, and_ff, or_ff;
    wire xor_in, and_in, or_in;

    // Combinational logic for gate inputs
    assign xor_in = x ^ xor_ff;
    assign and_in = x & ~and_ff;
    assign or_in  = x | ~or_ff;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        xor_ff <= xor_in;
        and_ff <= and_in;
        or_ff  <= or_in;
    end

    // Output NOR gate
    assign z = ~(xor_ff | and_ff | or_ff);

    // Initialization (for simulation)
    initial begin
        xor_ff = 0;
        and_ff = 0;
        or_ff  = 0;
    end

endmodule