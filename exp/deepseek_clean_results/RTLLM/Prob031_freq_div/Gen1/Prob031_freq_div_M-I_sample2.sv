module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10;
    
    // Gray-coded counter for 1MHz clock (divide by 100)
    reg [5:0] cnt_100_gray;
    wire [5:0] cnt_100_bin;
    
    // Convert Gray to binary for comparison
    assign cnt_100_bin[5] = cnt_100_gray[5];
    assign cnt_100_bin[4] = cnt_100_bin[5] ^ cnt_100_gray[4];
    assign cnt_100_bin[3] = cnt_100_bin[4] ^ cnt_100_gray[3];
    assign cnt_100_bin[2] = cnt_100_bin[3] ^ cnt_100_gray[2];
    assign cnt_100_bin[1] = cnt_100_bin[2] ^ cnt_100_gray[1];
    assign cnt_100_bin[0] = cnt_100_bin[1] ^ cnt_100_gray[0];

    // Combined reset and clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all outputs and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= 3'b0;
            cnt_100_gray <= 6'b0;
        end else begin
            // CLK_50 generation (divide by 2)
            CLK_50 <= ~CLK_50;
            
            // CLK_10 generation (divide by 10)
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b0;
            end else begin
                cnt_10 <= cnt_10 + 3'b1;
            end
            
            // CLK_1 generation (divide by 100) with Gray coding
            if (cnt_100_bin == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100_gray <= 6'b0;
            end else begin
                // Increment Gray counter
                case (cnt_100_gray)
                    6'b000000: cnt_100_gray <= 6'b000001;
                    6'b000001: cnt_100_gray <= 6'b000011;
                    6'b000011: cnt_100_gray <= 6'b000010;
                    // ... (full Gray code sequence up to 49)
                    6'b101111: cnt_100_gray <= 6'b101101;
                    6'b101101: cnt_100_gray <= 6'b101100;
                    6'b101100: cnt_100_gray <= 6'b100100;
                    default: cnt_100_gray <= cnt_100_gray + 1;
                endcase
            end
        end
    end

endmodule