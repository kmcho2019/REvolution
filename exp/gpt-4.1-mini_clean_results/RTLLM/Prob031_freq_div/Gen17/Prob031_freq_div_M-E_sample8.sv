module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    reg [6:0] cnt_100; // 7-bit counter for 0..99

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50   <= 1'b0;
            CLK_10   <= 1'b0;
            CLK_1    <= 1'b0;
            cnt_100  <= 7'd0;
        end else begin
            // 50MHz clock: toggle every clock (divide by 2)
            CLK_50 <= ~CLK_50;

            // Increment the shared counter and reset at 100
            if (cnt_100 == 7'd99) begin
                cnt_100 <= 7'd0;
            end else begin
                cnt_100 <= cnt_100 + 7'd1;
            end

            // 10MHz clock: toggle when counter hits 4, 9, 14, ..., 99 (every 5 counts)
            // Since toggling every 5 counts yields 10MHz from 100MHz input
            if (cnt_100 == 7'd4 || cnt_100 == 7'd9 || cnt_100 == 7'd14 || cnt_100 == 7'd19 ||
                cnt_100 == 7'd24 || cnt_100 == 7'd29 || cnt_100 == 7'd34 || cnt_100 == 7'd39 ||
                cnt_100 == 7'd44 || cnt_100 == 7'd49 || cnt_100 == 7'd54 || cnt_100 == 7'd59 ||
                cnt_100 == 7'd64 || cnt_100 == 7'd69 || cnt_100 == 7'd74 || cnt_100 == 7'd79 ||
                cnt_100 == 7'd84 || cnt_100 == 7'd89 || cnt_100 == 7'd94 || cnt_100 == 7'd99) begin
                CLK_10 <= ~CLK_10;
            end

            // 1MHz clock: toggle when counter reaches 49 (half period)
            if (cnt_100 == 7'd49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule