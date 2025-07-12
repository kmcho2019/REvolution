module TopModule (
    input clk,
    input x,
    output z
);

    // Flip-flop outputs
    reg xor_out = 0;
    reg and_out = 0;
    reg or_out = 0;

    // Combinational logic for D inputs
    wire xor_in = x ^ xor_out;
    wire and_in = x & ~and_out;
    wire or_in = x | ~or_out;

    // Sequential logic - flip-flop updates
    always @(posedge clk) begin
        xor_out <= xor_in;
        and_out <= and_in;
        or_out <= or_in;
    end

    // Output logic
    assign z = ~(xor_out | and_out | or_out);

endmodule