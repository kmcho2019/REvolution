module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    parameter DIV_50 = 1;      // 100MHz/2 = 50MHz
    parameter DIV_10 = 5;      // 100MHz/10 = 10MHz
    parameter DIV_1 = 50;      // 100MHz/100 = 1MHz

    reg [1:0] cnt10;           // counts 0-4 (5 cycles) - reduced to 2 bits
    reg [5:0] cnt100;          // counts 0-49 (50 cycles)
    wire [5:0] cnt100_gray;    // Gray coded version
    reg CLK_50_en = 1'b1;      // Clock gating control

    // Gray code conversion
    assign cnt100_gray = cnt100 ^ (cnt100 >> 1);

    // 50MHz clock (simple toggle)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else if (CLK_50_en) begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz clock
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt10 <= 0;
        end else begin
            if (cnt10 == DIV_10-1) begin
                CLK_10 <= ~CLK_10;
                cnt10 <= 0;
            end else begin
                cnt10 <= cnt10 + 1;
            end
        end
    end

    // 1MHz clock with Gray coded counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;
            cnt100 <= 0;
        end else begin
            if (cnt100 == DIV_1-1) begin
                CLK_1 <= ~CLK_1;
                cnt100 <= 0;
            end else begin
                cnt100 <= cnt100 + 1;
            end
        end
    end

endmodule