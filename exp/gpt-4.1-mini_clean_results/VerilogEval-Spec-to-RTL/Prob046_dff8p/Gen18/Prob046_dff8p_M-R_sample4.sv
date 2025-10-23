module SyncResetNegEdgeDFF (
    input       clk,
    input       reset,
    input       d,
    output reg  q
);
    // Negative edge triggered D flip-flop with synchronous active-high reset
    always @(negedge clk) begin
        if (reset)
            q <= 1'b0; // Default to zero here, but will override in instantiation for 0x34 bits.
        else
            q <= d;
    end
endmodule

module TopModule (
    input          clk,
    input          reset,
    input   [7:0]  d,
    output  [7:0]  q
);

    // The reset pattern 0x34 (00110100)
    // For each bit, instantiate one DFF with synchronous reset setting q to corresponding reset bit.
    wire [7:0] reset_pattern = 8'h34;

    // Generate 8 DFFs for each bit
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : dff_bits
            reg q_bit;
            always @(negedge clk) begin
                if (reset)
                    q_bit <= reset_pattern[i];
                else
                    q_bit <= d[i];
            end
            assign q[i] = q_bit;
        end
    endgenerate

endmodule