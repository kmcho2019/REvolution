module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Counter for 10MHz (divide by 10)
    reg [2:0] cnt_10;
    
    // Counter for 1MHz (divide by 100)
    reg [5:0] cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Reset all clocks and counters
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= 3'b0;
            cnt_100 <= 6'b0;
        end
        else begin
            // CLK_50 generation (divide by 2)
            CLK_50 <= ~CLK_50;
            
            // CLK_10 generation (divide by 10)
            if (cnt_10 == 3'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 3'b0;
            end
            else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
            
            // CLK_1 generation (divide by 100)
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b0;
            end
            else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule