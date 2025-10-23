module TopModule(
    input [7:0] in,
    // input enable,  // Optional enable signal for power gating
    output parity
);

    // Explicit XOR reduction
    assign parity = ^in[7:0];

    /* Alternative with enable (would require uncommenting enable port)
    reg parity_reg;
    always @(*) begin
        if (enable) begin
            parity_reg = ^in;
        end else begin
            parity_reg = 1'b0;  // Or maintain previous value if sequential
        end
    end
    assign parity = parity_reg;
    */
endmodule