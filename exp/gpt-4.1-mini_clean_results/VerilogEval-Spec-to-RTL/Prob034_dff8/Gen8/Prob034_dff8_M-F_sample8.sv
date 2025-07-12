module DFF(
    input clk,
    input d,
    output reg q
);
    initial q = 1'b0;  // Initialize output to zero to avoid simulation X states

    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule(
    input clk,
    input [7:0] d,
    output [7:0] q
);
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : dff_array
            DFF dff_inst (
                .clk(clk),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule