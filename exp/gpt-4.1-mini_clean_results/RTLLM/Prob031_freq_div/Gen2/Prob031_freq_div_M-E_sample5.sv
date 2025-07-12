module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counter widths calculated as needed:
    // For CLK_10: divide by 10 -> toggle every 5 cycles -> need 3 bits (count 0 to 4)
    reg [2:0] cnt_10;

    // For CLK_1: divide by 100 -> toggle every 50 cycles -> need 6 bits (count 0 to 49)
    reg [5:0] cnt_100;

    // CLK_50: toggle every cycle (divide by 2), no counter needed

    // CLK_50 generation: toggle every clock cycle
    always @(posedge CLK_in) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation: toggle every 5 cycles (divide by 10)
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == 3'd4) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // CLK_1 generation: toggle every 50 cycles (divide by 100)
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_100 == 6'd49) begin
                cnt_100 <= 6'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 1'b1;
            end
        end
    end

endmodule