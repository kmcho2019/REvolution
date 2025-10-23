module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 10MHz counter (divide by 10)
    reg [2:0] cnt_10;  // 3-bit counter (0-4)

    // 1MHz counter (divide by 100)
    reg [5:0] cnt_1;   // 6-bit counter (0-49)

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) CLK_50 <= 0;
        else CLK_50 <= ~CLK_50;
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt_10 <= 0;
        end else begin
            if (cnt_10 == 4) begin
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
            CLK_1 <= 0;
            cnt_1 <= 0;
        end else begin
            if (cnt_1 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt_1 <= 0;
            end else begin
                cnt_1 <= cnt_1 + 1;
            end
        end
    end

endmodule