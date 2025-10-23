module TopModule (
    input  [7:0] in,
    output       parity
);
    reg parity_reg;
    integer i;

    always @* begin
        parity_reg = 1'b0;
        // Compute even parity by XOR'ing each bit of the input vector sequentially.
        // This explicit procedural approach uses a for-loop to accumulate parity.
        for (i = 0; i < 8; i = i + 1) begin
            parity_reg = parity_reg ^ in[i];
        end
    end

    assign parity = parity_reg;
endmodule