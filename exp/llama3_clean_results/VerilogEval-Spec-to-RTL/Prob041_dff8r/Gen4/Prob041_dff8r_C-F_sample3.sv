module DFF(
    input clk,
    input reset,
    input d,
    output logic q
);

always_ff @(posedge clk) begin
    q <= reset ? 1'b0 : d;
end

endmodule

module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output logic [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        DFF dff_i(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule