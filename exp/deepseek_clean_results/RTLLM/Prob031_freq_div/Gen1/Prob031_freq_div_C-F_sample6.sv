module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for better maintainability
    parameter DIV_50 = 1;      // Divide by 2 (100MHz/2 = 50MHz)
    parameter DIV_10 = 4;      // Divide by 10 (100MHz/10 = 10MHz)
    parameter DIV_1 = 49;      // Divide by 100 (100MHz/100 = 1MHz)
    
    // Gray code counter for 1MHz clock (divide by 100)
    reg [5:0] cnt_100_gray;
    wire [5:0] cnt_100_bin;
    
    // Binary to Gray conversion
    assign cnt_100_bin = {cnt_100_gray[5], 
                         cnt_100_gray[5] ^ cnt_100_gray[4],
                         cnt_100_gray[4] ^ cnt_100_gray[3],
                         cnt_100_gray[3] ^ cnt_100_gray[2],
                         cnt_100_gray[2] ^ cnt_100_gray[1],
                         cnt_100_gray[1] ^ cnt_100_gray[0]};
    
    // Down counter for 10MHz clock (divide by 10)
    reg [2:0] cnt_10;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all clocks and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= DIV_10;
            cnt_100_gray <= 6'b0;
        end
        else begin
            // CLK_50 generation (divide by 2)
            CLK_50 <= ~CLK_50;
            
            // CLK_10 generation (divide by 10) using down counter
            if (cnt_10 == 3'b0) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= DIV_10;
            end
            else begin
                cnt_10 <= cnt_10 - 1'b1;
            end
            
            // CLK_1 generation (divide by 100) using Gray code counter
            if (cnt_100_bin == 6'b0) begin
                CLK_1 <= ~CLK_1;
                cnt_100_gray <= DIV_1 ^ (DIV_1 >> 1); // Initialize with Gray code
            end
            else begin
                // Gray code count down
                cnt_100_gray <= (cnt_100_gray - 1'b1) ^ ((cnt_100_gray - 1'b1) >> 1);
            end
        end
    end

endmodule