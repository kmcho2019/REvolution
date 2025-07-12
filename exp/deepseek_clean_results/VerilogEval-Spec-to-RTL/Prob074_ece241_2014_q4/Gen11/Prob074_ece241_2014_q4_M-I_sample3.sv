module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_out, and_out, or_out;
    wire xor_in, and_in, or_in;

    // Combinational logic for flip-flop inputs
    assign xor_in = x ^ xor_out;
    assign and_in = x & ~and_out;
    assign or_in = x | ~or_out;

    // Synchronous flip-flops with reset
    always @(posedge clk) begin
        xor_out <= 1'b0;  // Reset to 0 (as specified)
        and_out <= 1'b0;
        or_out <= 1'b0;
    end
    always @(posedge clk) begin
        xor_out <= xor_in;
        and_out <= and_in;
        or_out <= or_in;
    end

    // Output logic
    assign z = ~(xor_out | and_out | or_out);

endmodule