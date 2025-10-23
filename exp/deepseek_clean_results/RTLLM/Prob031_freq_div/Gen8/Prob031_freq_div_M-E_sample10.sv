module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 50MHz generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz generation (divide by 5 from 50MHz)
    reg [2:0] cnt5;
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt5 <= 0;
        end else begin
            if (cnt5 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt5 <= 0;
            end else begin
                cnt5 <= cnt5 + 1;
            end
        end
    end

    // 1MHz generation (divide by 10 from 10MHz)
    reg [3:0] cnt10;
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;
            cnt10 <= 0;
        end else begin
            if (cnt10 == 9) begin
                CLK_1 <= ~CLK_1;
                cnt10 <= 0;
            end else begin
                cnt10 <= cnt10 + 1;
            end
        end
    end

endmodule