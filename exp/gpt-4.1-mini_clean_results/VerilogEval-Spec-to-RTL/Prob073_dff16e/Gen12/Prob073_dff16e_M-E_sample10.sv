module TopModule (
    input          clk,
    input          resetn,
    input   [1:0]  byteena,
    input  [15:0]  d,
    output reg [15:0] q
);

genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : dffs
        wire write_enable;
        // Determine write enable based on byteena and bit position
        assign write_enable = (i < 8) ? byteena[0] : byteena[1];

        always @(posedge clk) begin
            if (!resetn)
                q[i] <= 1'b0;
            else if (write_enable)
                q[i] <= d[i];
            else
                q[i] <= q[i];
        end
    end
endgenerate

endmodule