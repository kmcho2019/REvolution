module TopModule(
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    reg [7:0] stage1_out_hi;
    reg [7:0] stage1_out_lo;

    // Stage 1: Extract upper and lower 8-bit bytes
    always @(*) begin
        stage1_out_hi = in[15:8];
        stage1_out_lo = in[7:0];
    end

    // Stage 2: Buffer the outputs (could be synchronized with a clock if needed)
    always @(posedge in[0] or negedge in[0]) begin // Assuming in[0] acts as a clock for demonstration
        out_hi <= stage1_out_hi;
        out_lo <= stage1_out_lo;
    end

endmodule