module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Gray code counters (reduces switching activity)
    reg [1:0] cnt5_gray;  // Divide by 5 counter (3 states needed)
    reg [3:0] cnt10_gray; // Divide by 10 counter
    
    // Binary to Gray conversion functions
    function [1:0] bin2gray5;
        input [1:0] b;
        begin
            bin2gray5 = {b[1], b[1] ^ b[0]};
        end
    endfunction
    
    function [3:0] bin2gray10;
        input [3:0] b;
        begin
            bin2gray10 = {b[3], b[3] ^ b[2], b[2] ^ b[1], b[1] ^ b[0]};
        end
    endfunction

    // 50MHz generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // 10MHz generation (divide 50MHz by 5)
    always @(posedge CLK_50 or posedge RST) begin
        if (RST) begin
            CLK_10 <= 0;
            cnt5_gray <= bin2gray5(2'd0);
        end else begin
            if (cnt5_gray == bin2gray5(2'd4)) begin
                CLK_10 <= ~CLK_10;
                cnt5_gray <= bin2gray5(2'd0);
            end else begin
                cnt5_gray <= bin2gray5((cnt5_gray[1] << 1) + cnt5_gray[0] + 1'b1);
            end
        end
    end

    // 1MHz generation (divide 10MHz by 10)
    always @(posedge CLK_10 or posedge RST) begin
        if (RST) begin
            CLK_1 <= 0;
            cnt10_gray <= bin2gray10(4'd0);
        end else begin
            if (cnt10_gray == bin2gray10(4'd9)) begin
                CLK_1 <= ~CLK_1;
                cnt10_gray <= bin2gray10(4'd0);
            end else begin
                cnt10_gray <= bin2gray10((cnt10_gray[3:0] + 1'b1));
            end
        end
    end

endmodule