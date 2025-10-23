module DFF (
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule

module TopModule (
    input wire clk,
    input wire [7:0] d,
    output wire [7:0] q
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            DFF dff_inst (
                .clk(clk),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule