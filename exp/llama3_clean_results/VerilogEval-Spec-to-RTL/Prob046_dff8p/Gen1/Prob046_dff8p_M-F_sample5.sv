// Custom D flip-flop with synchronous reset
module dff_sync_reset(
    input  clk,
    input  reset,
    input  d,
    output reg q
);
    always @(negedge clk) begin
        if (reset) begin
            // Reset to the specific value 0x34
            q <= 8'b00110100;
        end else begin
            q <= d;
        end
    end
endmodule

module TopModule(
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

// 8-bit register with custom D flip-flops
genvar i;
generate
    for (i = 0; i < 8; i++) begin : dff_gen
        dff_sync_reset u_dff(
            .clk(clk),
            .reset(reset),
            .d(d[i]),
            .q(q[i])
        );
    end
endgenerate

endmodule