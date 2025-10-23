module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    reg [5:0] cnt_10;  // Needs to count up to 4 (0-4 is 5 counts)
    reg [6:0] cnt_100; // Needs to count up to 49 (0-49 is 50 counts)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= 6'b0;
            cnt_100 <= 7'b0;
        end
        else begin
            // CLK_50 generation (divide by 2)
            CLK_50 <= ~CLK_50;

            // CLK_10 generation (divide by 10)
            if (cnt_10 == 6'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 6'b0;
            end
            else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // CLK_1 generation (divide by 100)
            if (cnt_100 == 7'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 7'b0;
            end
            else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule