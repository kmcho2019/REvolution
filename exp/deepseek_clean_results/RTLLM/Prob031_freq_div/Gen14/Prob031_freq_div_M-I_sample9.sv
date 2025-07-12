module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Fixed division ratios
    localparam DIV_50 = 2;
    localparam DIV_10 = 10;
    localparam DIV_1 = 10; // Now relative to CLK_10

    // Gray code counters (widths optimized for fixed ratios)
    reg [2:0] cnt10_gray;  // 3-bit for divide by 10 (actual max 4)
    reg [2:0] cnt1_gray;   // 3-bit for divide by 10 (from CLK_10)

    // Gray code increment functions
    function [2:0] gray_inc;
        input [2:0] gray;
        begin
            case(gray)
                3'b000: gray_inc = 3'b001;
                3'b001: gray_inc = 3'b011;
                3'b011: gray_inc = 3'b010;
                3'b010: gray_inc = 3'b110;
                3'b110: gray_inc = 3'b111;
                3'b111: gray_inc = 3'b101;
                3'b101: gray_inc = 3'b100;
                3'b100: gray_inc = 3'b000;
                default: gray_inc = 3'b000;
            endcase
        end
    endfunction

    // 50MHz generation (separate always block)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) CLK_50 <= 0;
        else CLK_50 <= ~CLK_50;
    end

    // 10MHz generation with Gray code counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt10_gray <= 3'b000;
        end else begin
            cnt10_gray <= gray_inc(cnt10_gray);
            if (cnt10_gray == 3'b100) begin  // Counts 0-4 (5 cycles)
                CLK_10 <= ~CLK_10;
                cnt10_gray <= 3'b000;
            end
        end
    end

    // 1MHz generation (from CLK_10) with Gray code counter
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;
            cnt1_gray <= 3'b000;
        end else begin
            cnt1_gray <= gray_inc(cnt1_gray);
            if (cnt1_gray == 3'b100) begin  // Counts 0-4 (5 cycles)
                CLK_1 <= ~CLK_1;
                cnt1_gray <= 3'b000;
            end
        end
    end

endmodule