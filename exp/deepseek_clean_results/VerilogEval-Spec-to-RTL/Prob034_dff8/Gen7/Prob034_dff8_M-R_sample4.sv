module TopModule #(
    parameter USE_RESET = 0
) (
    input        clk,
    input  [7:0] d,
    output [7:0] q,
    input        rst_n
);

wire [7:0] q_wire;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        reg dff;
        
        always @(posedge clk) begin
            if (USE_RESET && !rst_n)
                dff <= 1'b0;
            else
                dff <= d[i];
        end
        
        assign q_wire[i] = dff;
    end
endgenerate

assign q = q_wire;

endmodule