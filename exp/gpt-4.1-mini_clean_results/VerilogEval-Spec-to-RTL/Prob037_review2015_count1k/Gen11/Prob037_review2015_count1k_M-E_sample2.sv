module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    // Separate counters for decimal digits:
    // lsd (least significant digit): 4 bits (0-9)
    // msd (most significant digits): 7 bits (0-99)
    reg [3:0] lsd;  // 0 to 9
    reg [6:0] msd;  // 0 to 99

    always @(posedge clk) begin
        if (reset) begin
            lsd <= 4'd0;
            msd <= 7'd0;
            q <= 10'd0;
        end else begin
            if (lsd == 4'd9) begin
                lsd <= 4'd0;
                if (msd == 7'd99) begin
                    msd <= 7'd0;
                end else begin
                    msd <= msd + 7'd1;
                end
            end else begin
                lsd <= lsd + 4'd1;
            end
            q <= {msd, lsd};
        end
    end

endmodule