module freq_div #(
    parameter DIV_50 = 2,    // Division ratio for 50MHz
    parameter DIV_10 = 10,   // Division ratio for 10MHz
    parameter DIV_1 = 100    // Division ratio for 1MHz
)(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Gray code counters for reduced switching activity
    reg [2:0] cnt_10_gray;
    reg [5:0] cnt_100_gray;
    
    // Binary equivalents for comparison
    wire [2:0] cnt_10_bin;
    wire [5:0] cnt_100_bin;
    
    // Gray to binary conversion
    assign cnt_10_bin = {cnt_10_gray[2],
                        cnt_10_gray[2] ^ cnt_10_gray[1],
                        cnt_10_gray[2] ^ cnt_10_gray[1] ^ cnt_10_gray[0]};
    
    assign cnt_100_bin = {cnt_100_gray[5],
                         cnt_100_gray[5] ^ cnt_100_gray[4],
                         cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3],
                         cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3] ^ cnt_100_gray[2],
                         cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3] ^ cnt_100_gray[2] ^ cnt_100_gray[1],
                         cnt_100_gray[5] ^ cnt_100_gray[4] ^ cnt_100_gray[3] ^ cnt_100_gray[2] ^ cnt_100_gray[1] ^ cnt_100_gray[0]};

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all clocks and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10_gray <= 3'b0;
            cnt_100_gray <= 6'b0;
        end
        else begin
            // CLK_50 generation (divide by DIV_50)
            CLK_50 <= ~CLK_50;

            // CLK_10 generation (divide by DIV_10)
            if (cnt_10_bin == (DIV_10/2 - 1)) begin
                CLK_10 <= ~CLK_10;
                cnt_10_gray <= 3'b0;
            end
            else begin
                // Increment Gray code counter
                cnt_10_gray <= cnt_10_gray ^ {2'b0, |cnt_10_gray[1:0]} ^ {1'b0, |cnt_10_gray[0], 1'b0};
            end

            // CLK_1 generation (divide by DIV_1)
            if (cnt_100_bin == (DIV_1/2 - 1)) begin
                CLK_1 <= ~CLK_1;
                cnt_100_gray <= 6'b0;
            end
            else begin
                // Increment Gray code counter
                cnt_100_gray <= cnt_100_gray ^ 
                               {5'b0, |cnt_100_gray[4:0]} ^ 
                               {4'b0, |cnt_100_gray[3:0], 1'b0} ^ 
                               {3'b0, |cnt_100_gray[2:0], 2'b0} ^ 
                               {2'b0, |cnt_100_gray[1:0], 3'b0} ^ 
                               {1'b0, |cnt_100_gray[0], 4'b0};
            end
        end
    end

endmodule