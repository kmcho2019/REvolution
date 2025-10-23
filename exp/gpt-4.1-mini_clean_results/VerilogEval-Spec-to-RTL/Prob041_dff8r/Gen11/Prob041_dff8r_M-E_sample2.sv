module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    genvar i;
    // Declare internal reg array for outputs
    reg [7:0] q_reg;

    // Generate 8 DFFs, one per bit
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_gen
            always @(posedge clk) begin
                if (reset)
                    q_reg[i] <= 1'b0;
                else
                    q_reg[i] <= d[i];
            end
        end
    endgenerate

    assign q = q_reg;
endmodule