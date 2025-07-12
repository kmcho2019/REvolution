module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_2; // 2 is 2^1 + 1, but for 2 it is [1:0] not [2:0] and not [3:0] 
reg [2:0] cnt_10; // 10 is 2^3 + 2, but for 10 it is [2:0] not [3:0] and not [4:0] 
reg [5:0] cnt_100; // 100 is 2^6 + 2^5 + 2^2, but for 100 it is [5:0] not [6:0] and not [7:0] 

always @(posedge CLK_in or posedge RST) begin
    if(RST) begin
        CLK_50 <= 1'b0;
        cnt_2 <= 2'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 3'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        // Generate 50MHz clock signal
        if (cnt_2 == 2'b1) begin
            CLK_50 <= ~CLK_50;
            cnt_2 <= 2'b0;
        end else begin
            cnt_2 <= cnt_2 + 1;
        end

        // Generate 10MHz clock signal
        if (cnt_10 == 3'b100) begin // 4 in binary is 100
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'b0;
        end else begin
            cnt_10 <= cnt_10 + 1;
        end

        // Generate 1MHz clock signal
        if (cnt_100 == 6'b110001) begin // 49 in binary is 110001
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end else begin
            cnt_100 <= cnt_100 + 1;
        end
    end
end

endmodule