module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

localparam RESET_VAL = 8'h34;
genvar i;

generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg dff;
        always @(negedge clk) begin
            if (reset) begin
                dff <= RESET_VAL[i];
            end else begin
                dff <= d[i];
            end
        end
        assign q[i] = dff;
    end
endgenerate

endmodule