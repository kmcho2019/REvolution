module TopModule (
    input         clk,
    input         reset,
    input  [7:0]  d,
    output [7:0]  q
);
    // Internal register vector
    reg [7:0] q_reg;

    // Generate 8 flip-flops, each handling one bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bit
            always @(negedge clk) begin
                if (reset)
                    q_reg[i] <= 1'b0;  // Will override next to reset vector bits
                else
                    q_reg[i] <= d[i];
            end
        end
    endgenerate

    // Synchronous reset to 8'h34 bits applied after negedge clk sampling
    // To implement synchronous reset to 0x34 as vector, override bits on reset:
    // However, since synchronous reset affects all bits simultaneously, 
    // it's easier to integrate reset value inside each always block. 
    // So we adjust the code to assign bit of 0x34 instead of 0 here:

    // Replacing the above per-bit always block with reset vector bits:

    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_bit_with_reset
            always @(negedge clk) begin
                if (reset)
                    q_reg[i] <= 8'h34[i];
                else
                    q_reg[i] <= d[i];
            end
        end
    endgenerate

    // Output assignment
    assign q = q_reg;

endmodule