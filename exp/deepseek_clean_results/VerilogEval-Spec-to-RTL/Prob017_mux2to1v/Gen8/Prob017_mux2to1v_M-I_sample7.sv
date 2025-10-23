module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    input         en,    // New enable signal for power gating
    output reg [99:0] out
);

    // Buffer tree for select signal to reduce fanout
    wire [9:0] sel_buf;
    genvar i;
    generate
        for (i = 0; i < 10; i = i + 1) begin : sel_buf_tree
            buf b1(sel_buf[i], sel);
        end
    endgenerate

    // Hierarchical 10-bit mux blocks
    always @(*) begin
        if (en) begin
            for (integer j = 0; j < 10; j = j + 1) begin
                out[j*10 +: 10] = sel_buf[j] ? b[j*10 +: 10] : a[j*10 +: 10];
            end
        end else begin
            out = 100'b0;  // Power-gated output
        end
    end

endmodule