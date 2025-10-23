module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counters
    reg [2:0] cnt_10;  // 0-4 counter for 10MHz (5 cycles)
    reg [6:0] cnt_100; // 0-49 counter for 1MHz (50 cycles)

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) CLK_50 <= 1'b0;
        else CLK_50 <= ~CLK_50;
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else begin
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'd0;
            end else begin
                cnt_10 <= cnt_10 + 3'd1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 7'd0;
        end else begin
            if (cnt_100 == 7'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 7'd0;
            end else begin
                cnt_100 <= cnt_100 + 7'd1;
            end
        end
    end

endmodule