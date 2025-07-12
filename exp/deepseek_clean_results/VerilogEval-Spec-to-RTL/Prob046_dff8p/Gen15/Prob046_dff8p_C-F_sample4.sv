module NegEdgeDFF (
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

localparam [7:0] RESET_VAL = 8'h34;  // Binary: 00110100

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_chain
        NegEdgeDFF dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .reset_val(RESET_VAL[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule