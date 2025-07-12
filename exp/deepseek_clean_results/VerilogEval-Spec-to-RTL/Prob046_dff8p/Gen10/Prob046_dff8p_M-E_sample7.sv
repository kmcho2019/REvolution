module DFF_neg (
    input clk,
    input reset,
    input d,
    input reset_val,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= reset_val;
    end else begin
        q <= d;
    end
end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        DFF_neg dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .reset_val((8'h34 >> i) & 1'b1),  // Extract each bit of reset value
            .q(q[i])
        );
    end
endgenerate

endmodule