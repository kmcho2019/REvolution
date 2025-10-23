module freq_div(
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
    );

reg [1:0] cnt_10; // 2-bit counter for 10MHz clock
reg [5:0] cnt_100; // 6-bit counter for 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin // reset all signals and counters
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        cnt_10 <= 2'b0;
        CLK_1 <= 1'b0;
        cnt_100 <= 6'b0;
    end else begin
        // toggle CLK_50
        CLK_50 <= ~CLK_50;
        
        // generate CLK_10
        if (cnt_10 == 4'd9) begin // 5 cycles = 10MHz
            CLK_10 <= ~CLK_10;
            cnt_10 <= 2'b0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // generate CLK_1
        if (cnt_100 == 6'd49) begin // 50 cycles = 1MHz
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'b0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule