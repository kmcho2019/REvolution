module TopModule (
    input           clk,
    input           reset,
    input   [7:0]   d,
    output  [7:0]   q
);
    reg q_reg [7:0];  // 8 individual 1-bit registers

    integer i;
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                q_reg[i] <= 1'b0;
        end else begin
            for (i = 0; i < 8; i = i + 1)
                q_reg[i] <= d[i];
        end
    end

    // Concatenate array bits into vector output
    generate
        genvar j;
        for (j = 0; j < 8; j = j + 1) begin : out_assign
            assign q[j] = q_reg[j];
        end
    endgenerate
endmodule