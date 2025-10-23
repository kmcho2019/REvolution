module TopModule (
    input        clk,
    input        reset,
    input  [7:0] d,
    output [7:0] q
);

    // Internal regs for each bit of q
    reg [7:0] q_reg;

    // Assign output from internal regs
    assign q = q_reg;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bits
            always @(negedge clk) begin
                if (reset)
                    // Reset to corresponding bit of 0x34
                    q_reg[i] <= 8'h34[i];
                else
                    q_reg[i] <= d[i];
            end
        end
    endgenerate

endmodule