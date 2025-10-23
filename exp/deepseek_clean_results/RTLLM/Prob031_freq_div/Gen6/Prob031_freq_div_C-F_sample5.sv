module freq_div (
    input CLK_in,
    input RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division factors
    localparam DIV_50 = 2;    // 100MHz / 2 = 50MHz
    localparam DIV_10 = 10;   // 100MHz / 10 = 10MHz
    localparam DIV_1 = 100;   // 100MHz / 100 = 1MHz

    // Counters with optimal bit-widths
    reg [1:0] cnt_10;   // counts 0-4 (5 cycles, needs 2 bits)
    reg [5:0] cnt_100;  // counts 0-49 (50 cycles, needs 6 bits)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            // Synchronous reset
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_10 <= 2'b0;
            cnt_100 <= 6'b0;
        end else begin
            // 50MHz clock (divide by 2) - simple toggle
            CLK_50 <= ~CLK_50;
            
            // 10MHz clock (divide by 10)
            if (cnt_10 == 2'd4) begin  // Count 0-4 (5 cycles)
                CLK_10 <= ~CLK_10;
                cnt_10 <= 2'b0;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
            
            // 1MHz clock (divide by 100)
            if (cnt_100 == 6'd49) begin  // Count 0-49 (50 cycles)
                CLK_1 <= ~CLK_1;
                cnt_100 <= 6'b0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule