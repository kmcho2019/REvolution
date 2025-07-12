module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter for divide by 10 clock (toggle every 5 counts)
    reg [2:0] cnt_10;

    // Counter for divide by 100 clock (toggle every 50 counts)
    reg [5:0] cnt_100;

    // CLK_50: divide by 2, toggled every clock cycle
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 and CLK_1: divide by 10 and divide by 100 using counters
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            cnt_100 <= 6'd0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Divide by 10: toggle every 5 clocks (count 0..4)
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end

            // Divide by 100: toggle every 50 clocks (count 0..49)
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule