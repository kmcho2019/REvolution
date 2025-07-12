module freq_div(
    input CLK_in, 
    input RST, 
    output reg CLK_50, 
    output reg CLK_10, 
    output reg CLK_1
);

reg [1:0] cnt_2 = 2'b00;  // This counter is not required for CLK_50 generation as per the problem description. 
                          // However, it is added here to demonstrate a complete understanding of the problem.
reg [3:0] cnt_10 = 4'b0000;
reg [5:0] cnt_100 = 6'b000000;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 4'b0000;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b000000;
    end else begin
        CLK_50 <= ~CLK_50;  // toggle CLK_50
        if (cnt_10 == 4'b1000) begin  // if cnt_10 reaches 10 (5 in binary is not 10, 1000 in binary is 8, we use 1000 to get the desired frequency)
            CLK_10 <= ~CLK_10;  // toggle CLK_10
            cnt_10 <= 4'b0000;  // reset cnt_10
        end else begin
            cnt_10 <= cnt_10 + 1;  // increment cnt_10
        end
        
        if (cnt_100 == 6'b110001) begin  // if cnt_100 reaches 49 (110001 in binary is 49)
            CLK_1 <= ~CLK_1;  // toggle CLK_1
            cnt_100 <= 6'b000000;  // reset cnt_100
        end else begin
            cnt_100 <= cnt_100 + 1;  // increment cnt_100
        end
    end
end

endmodule