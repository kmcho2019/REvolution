module freq_div(
    input           CLK_in,
    input           RST,
    output          CLK_50,
    output          CLK_10,
    output          CLK_1
);

reg     CLK_50;
reg     CLK_10;
reg     CLK_1;
reg [1:0]  cnt_2;  // Counter for 50MHz
reg [3:0]  cnt_10; // Counter for 10MHz
reg [6:0]  cnt_100; // Counter for 1MHz

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // Reset all counters and output clocks
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b0;
        cnt_10 <= 4'b0;
        cnt_100 <= 7'b0;
    end else begin
        // Generate 50MHz clock
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end

        // Generate 10MHz clock
        if (cnt_10 == 4'b1000) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Generate 1MHz clock
        if (cnt_100 == 7'b110001) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule