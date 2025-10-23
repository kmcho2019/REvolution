module freq_div(CLK_in, RST, CLK_50, CLK_10, CLK_1);
    input CLK_in;
    input RST;
    output reg CLK_50;
    output reg CLK_10;
    output reg CLK_1;
    reg [4:0] cnt_10;
    reg [5:0] cnt_100;

    always @(posedge CLK_in, posedge RST) begin
        if (RST) begin
            // Reset all signals
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= 5'd0;
            cnt_100 <= 6'd0;
        end else begin
            // Toggle CLK_50
            CLK_50 <= ~CLK_50;
            
            // Generate CLK_10
            if (cnt_10 == 5'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 5'd0;
            end else begin
                cnt_10 <= cnt_10 + 5'd1;
            end

            // Generate CLK_1
            if (cnt_100 == 6'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'd0;
            end else begin
                cnt_100 <= cnt_100 + 6'd1;
            end
        end
    end
endmodule