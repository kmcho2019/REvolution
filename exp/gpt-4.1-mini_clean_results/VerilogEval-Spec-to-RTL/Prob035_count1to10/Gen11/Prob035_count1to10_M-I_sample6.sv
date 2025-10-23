module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);
    // Gray code sequence for decimal 1 to 10:
    // Decimal: Binary : Gray
    // 1 : 0001 : 0001
    // 2 : 0010 : 0011
    // 3 : 0011 : 0010
    // 4 : 0100 : 0110
    // 5 : 0101 : 0111
    // 6 : 0110 : 0101
    // 7 : 0111 : 0100
    // 8 : 1000 : 1100
    // 9 : 1001 : 1101
    // 10: 1010 : 1111

    reg [3:0] gray_count;

    // Function to convert Gray to binary (for output q)
    function [3:0] gray_to_bin;
        input [3:0] g;
        begin
            gray_to_bin[3] = g[3];
            gray_to_bin[2] = gray_to_bin[3] ^ g[2];
            gray_to_bin[1] = gray_to_bin[2] ^ g[1];
            gray_to_bin[0] = gray_to_bin[1] ^ g[0];
        end
    endfunction

    // Function to get next Gray code in sequence (1 to 10)
    function [3:0] next_gray;
        input [3:0] g;
        begin
            case(g)
                4'b0001: next_gray = 4'b0011; // 1->2
                4'b0011: next_gray = 4'b0010; // 2->3
                4'b0010: next_gray = 4'b0110; // 3->4
                4'b0110: next_gray = 4'b0111; // 4->5
                4'b0111: next_gray = 4'b0101; // 5->6
                4'b0101: next_gray = 4'b0100; // 6->7
                4'b0100: next_gray = 4'b1100; // 7->8
                4'b1100: next_gray = 4'b1101; // 8->9
                4'b1101: next_gray = 4'b1111; // 9->10
                4'b1111: next_gray = 4'b0001; // 10->1 (rollover)
                default: next_gray = 4'b0001; // default/reset to 1
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            gray_count <= 4'b0001; // Gray code of decimal 1
        end else begin
            gray_count <= next_gray(gray_count);
        end
    end

    always @(*) begin
        q = gray_to_bin(gray_count);
    end

endmodule