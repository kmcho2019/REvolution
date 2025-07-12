module TopModule(
    input  clk,
    input  reset,
    input  [7:0] d,
    output [7:0] q
);

// Custom D flip-flop with synchronous reset
module dff_sync_reset(
    input  clk,
    input  reset,
    input  d,
    output reg q
);
    always @(negedge clk) begin
        if (reset) begin
            q <= 1'b0; // Reset to 0
        end else begin
            q <= d;
        end
    end
endmodule

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

// To reset to a specific value (0x34), we need to add an extra logic
// to handle the reset value. We'll use a reg to hold the reset value.
reg [7:0] reset_value;
always @(posedge reset) begin
    reset_value <= 8'b00110100; // 0x34
end
always @(negedge clk) begin
    if (reset) begin
        q <= reset_value;
    end
end

endmodule