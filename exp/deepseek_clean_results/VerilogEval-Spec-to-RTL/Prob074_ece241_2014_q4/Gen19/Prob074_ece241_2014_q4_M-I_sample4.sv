module TopModule (
    input clk,
    input x,
    output z
);

    reg xor_out, and_out, or_out;

    // Combinational logic for gate inputs
    wire xor_in = x ^ xor_out;
    wire and_in = x & ~and_out;
    wire or_in = x | ~or_out;

    // Sequential logic with asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            xor_out <= 1'b0;
            and_out <= 1'b0;
            or_out <= 1'b0;
        end else begin
            xor_out <= xor_in;
            and_out <= and_in;
            or_out <= or_in;
        end
    end

    // Reset generation (active low)
    reg rst_n = 1'b0;
    initial begin
        #1 rst_n = 1'b1;  // Release reset after initial delay
    end

    // Output NOR gate
    assign z = ~(xor_out | and_out | or_out);

endmodule