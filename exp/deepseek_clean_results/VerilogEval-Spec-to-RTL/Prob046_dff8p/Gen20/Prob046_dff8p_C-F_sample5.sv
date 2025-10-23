module NegEdgeDFF #(
    parameter RESET_VAL = 1'b0
) (
    input clk,
    input reset,
    input d,
    output reg q
);

always @(negedge clk) begin
    if (reset) begin
        q <= RESET_VAL;
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

// Reset value 0x34 = binary 00110100
localparam [7:0] RESET_VAL = 8'b00110100;

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        NegEdgeDFF #(.RESET_VAL(RESET_VAL[i])) dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule