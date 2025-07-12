module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);
    reg [1:0] cnt_2;
    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_2 <= 2'b00;
            cnt_10 <= 3'b000;
            cnt_100 <= 6'b000000;
        end else begin
            // Generate 50 MHz clock
            if (cnt_2 == 2'b01) begin
                CLK_50 <= ~CLK_50;
                cnt_2 <= 2'b00;
            end else begin
                cnt_2 <= cnt_2 + 1;
            end

            // Generate 10 MHz clock
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b000;
            end else begin
                cnt_10 <= cnt_10 + 1;
            end

            // Generate 1 MHz clock
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b000000;
            end else begin
                cnt_100 <= cnt_100 + 1;
            end
        end
    end
endmodule