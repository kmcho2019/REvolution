module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Single 7-bit counter to count from 0 to 99 for 10MHz and 1MHz clocks
    reg [6:0] cnt_100;

    // Generate 50MHz clock by toggling every CLK_in cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // Counter for 10MHz and 1MHz clocks division
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 7'd0;
            CLK_10 <= 1'b0;
            CLK_1  <= 1'b0;
        end else begin
            if (cnt_100 == 7'd99) begin
                cnt_100 <= 7'd0;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end

            // Toggle CLK_10 when counter reaches 4, 9, 14, ... i.e. every 5 counts (half period)
            if (cnt_100 == 7'd4 || cnt_100 == 7'd9 || cnt_100 == 7'd14 || cnt_100 == 7'd19 ||
                cnt_100 == 7'd24 || cnt_100 == 7'd29 || cnt_100 == 7'd34 || cnt_100 == 7'd39 ||
                cnt_100 == 7'd44 || cnt_100 == 7'd49 || cnt_100 == 7'd54 || cnt_100 == 7'd59 ||
                cnt_100 == 7'd64 || cnt_100 == 7'd69 || cnt_100 == 7'd74 || cnt_100 == 7'd79 ||
                cnt_100 == 7'd84 || cnt_100 == 7'd89 || cnt_100 == 7'd94 || cnt_100 == 7'd99) begin
                CLK_10 <= ~CLK_10;
            end

            // Toggle CLK_1 when counter reaches 49 and 99 (half period of 100)
            if (cnt_100 == 7'd49 || cnt_100 == 7'd99) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule