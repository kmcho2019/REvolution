module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    localparam DIV_10 = 4;  // Count to 4 (5 cycles)
    localparam DIV_100 = 49; // Count to 49 (50 cycles)

    reg [2:0] cnt_10;   // 3-bit counter (0-4)
    reg [5:0] cnt_100;  // 6-bit counter (0-49)

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) CLK_50 <= 1'b0;
        else CLK_50 <= ~CLK_50;
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 0;
        end else begin
            if (cnt_10 == DIV_10) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 0;
        end else begin
            if (cnt_100 == DIV_100) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 0;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end

endmodule