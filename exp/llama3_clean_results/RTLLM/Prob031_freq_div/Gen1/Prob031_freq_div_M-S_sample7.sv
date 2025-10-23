module freq_div(
    input CLK_in, 
    input RST, 
    output reg CLK_50, 
    output reg CLK_10, 
    output reg CLK_1
);
    
    reg [1:0] cnt_2;
    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 0;
            cnt_2 <= 0;
            CLK_10 <= 0;
            cnt_10 <= 0;
            CLK_1 <= 0;
            cnt_100 <= 0;
        end else begin
            // Generate 50MHz clock signal
            cnt_2 <= cnt_2 + 1;
            if (cnt_2 == 1) begin
                CLK_50 <= ~CLK_50;
                cnt_2 <= 0;
            end
            
            // Generate 10MHz clock signal
            cnt_10 <= cnt_10 + 1;
            if (cnt_10 == 4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 0;
            end
            
            // Generate 1MHz clock signal
            cnt_100 <= cnt_100 + 1;
            if (cnt_100 == 49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 0;
            end
        end
    end

endmodule