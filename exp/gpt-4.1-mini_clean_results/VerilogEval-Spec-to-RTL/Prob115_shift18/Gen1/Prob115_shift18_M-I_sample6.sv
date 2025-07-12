module TopModule (
    input          clk,
    input          load,
    input          ena,
    input  [1:0]   amount,
    input  [63:0]  data,
    output reg [63:0] q
);

    reg [63:0] stage1;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else if (ena) begin
            // Decompose shifting into two stages: shift by 8 then shift by 1, with direction
            if (amount[1] == 1'b0) begin
                // shift left
                // Stage 1: shift by 8 if amount[0] == 1 else no shift
                stage1 = amount[0] ? (q << 8) : q;
                // Stage 2: shift by 1 if amount[0] == 0 else no shift
                // Actually, only one bit shift left if amount == 00, else already shifted by 8
                // So, for amount==00: shift left by 1
                // For amount==01: shift left by 8 (done in stage1), no further shift
                if (amount == 2'b00)
                    q <= stage1 << 1;
                else
                    q <= stage1;
            end else begin
                // shift right (arithmetic)
                // Stage 1: shift right by 8 if amount[0] == 1 else no shift
                if (amount[0])
                    stage1 = $signed(q) >>> 8;
                else
                    stage1 = q;
                // Stage 2: shift right by 1 if amount[0] == 0 else no further shift
                // For amount == 10: shift right by 1 (done here)
                // For amount == 11: shift right by 8 (done in stage1)
                if (amount == 2'b10)
                    q <= $signed(stage1) >>> 1;
                else
                    q <= stage1;
            end
        end
        // else retain q
    end

endmodule