module TopModule (
    input          clk,
    input          reset,
    input  [7:0]   d,
    output reg [7:0]   q
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            always @(negedge clk) begin
                if (reset)
                    q[i] <= 1'b0 | (8'h34[i]); // reset bit from 8'h34
                else
                    q[i] <= d[i];
            end
        end
    endgenerate

endmodule