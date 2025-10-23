module DFF_sync_reset_en (
    input       clk,
    input       reset,
    input       en,
    input       d,
    output reg  q
);
    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (en)
            q <= d;
    end
endmodule

module TopModule (
    input           clk,
    input           reset,
    input  [7:0]    d,
    output [7:0]    q
);
    wire [7:0] en_bits;
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : dff_array
            // Enable this bit if reset is active or if input bit differs from output bit
            assign en_bits[i] = reset | (d[i] != q[i]);
            DFF_sync_reset_en dff_inst (
                .clk(clk),
                .reset(reset),
                .en(en_bits[i]),
                .d(d[i]),
                .q(q[i])
            );
        end
    endgenerate
endmodule