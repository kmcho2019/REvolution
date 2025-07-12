module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Constants for counter limits
    localparam CNT_10_LIMIT = 3'd4;   // 5 cycles (0-4)
    localparam CNT_100_LIMIT = 6'd49; // 50 cycles (0-49)
    
    // Counter for 10MHz (divide by 10)
    reg [2:0] cnt_10;
    // Counter for 1MHz (divide by 100)
    reg [5:0] cnt_100;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (divide by 10)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'b0;
        end else begin
            if (cnt_10 == CNT_10_LIMIT) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation (divide by 100)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'b0;
        end else begin
            if (cnt_100 == CNT_100_LIMIT) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule