module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [2:0] cnt_10;    // Counts up to 4 for 10MHz toggle
    reg [5:0] cnt_100;   // Counts up to 49 for 1MHz toggle

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50  <= 1'b0;
            CLK_10  <= 1'b0;
            CLK_1   <= 1'b0;
            cnt_10  <= 3'd0;
            cnt_100 <= 6'd0;
        end else begin
            // 50MHz clock: toggle every clock cycle (divide by 2)
            CLK_50 <= ~CLK_50;

            // 10MHz clock: toggle every 5 CLK_in cycles (divide by 10)
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // 1MHz clock: toggle every 50 CLK_in cycles (divide by 100)
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule