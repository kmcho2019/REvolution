module DFF (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);
    // Generate 8 instances of DFF, one per bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF dff_inst(
                .clk(clk),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule