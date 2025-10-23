module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_out, and_out, or_out;
    reg reset = 1'b1;  // Active-high reset

    // Combinational logic for gate inputs
    wire xor_in = x ^ xor_out;
    wire and_in = x & ~and_out;
    wire or_in = x | ~or_out;

    // Sequential logic with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            xor_out <= 1'b0;
            and_out <= 1'b0;
            or_out <= 1'b0;
            reset <= 1'b0;  // Deassert reset after first cycle
        end else begin
            xor_out <= xor_in;
            and_out <= and_in;
            or_out <= or_in;
        end
    end

    // Output NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule