module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_out, and_out, or_out;
    wire xor_in, and_in, or_in;

    // Combinational logic for gate inputs
    assign xor_in = x ^ xor_out;
    assign and_in = x & ~and_out;
    assign or_in = x | ~or_out;

    // Sequential logic with synchronous reset to 0
    always @(posedge clk) begin
        xor_out <= xor_in;
        and_out <= and_in;
        or_out <= or_in;
    end

    // Initialization to meet specification
    initial begin
        xor_out = 0;
        and_out = 0;
        or_out = 0;
    end

    // Output NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule