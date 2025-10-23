module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : dff_gen
        // Each DFF gets its corresponding bit from d and reset value from 0x34
        DFF_NEG dff_inst (
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i]),
            .reset_val( (i == 2 || i == 3 || i == 5) ? 1'b1 : 1'b0 )
            // Reset value mapping:
            // 0x34 = 8'b00110100
            // Bit positions: 2,3,5 are 1, others are 0
        );
    end
endgenerate

endmodule

module DFF_NEG (
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