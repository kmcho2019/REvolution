module freq_div(
    input  wire        CLK_in,
    input  wire        RST,
    output reg         CLK_50,
    output reg         CLK_10,
    output reg         CLK_1
);

reg [1:0] cnt_2;  // counter for 50MHz clock
reg [3:0] cnt_10; // counter for 10MHz clock
reg [6:0] cnt_100; // counter for 1MHz clock

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        // reset counters and output clock signals
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
        cnt_2 <= 2'b0;
        cnt_10 <= 4'b0;
        cnt_100 <= 7'b0;
    end else begin
        // toggle 50MHz clock
        CLK_50 <= ~CLK_50;
        
        // generate 10MHz clock
        if (cnt_10 == 4'b1001) begin
            // toggle 10MHz clock and reset counter
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4'b0;
        end else begin
            // increment counter
            cnt_10 <= cnt_10 + 1'b1;
        end
        
        // generate 1MHz clock
        if (cnt_100 == 7'b110001) begin
            // toggle 1MHz clock and reset counter
            CLK_1 <= ~CLK_1;
            cnt_100 <= 7'b0;
        end else begin
            // increment counter
            cnt_100 <= cnt_100 + 1'b1;
        end
    end
end

endmodule