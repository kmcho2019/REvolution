module TopModule (
    input        clk,
    input  [7:0] d,
    output reg [7:0] q
);

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_loop
            always @(posedge clk) begin
                q[i] <= d[i];
            end
        end
    endgenerate

endmodule