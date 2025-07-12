module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counters with minimal bit-widths for efficiency
    reg [2:0]  cnt_10;    // Counts 0 to 4 for divide by 10
    reg [5:0]  cnt_100;   // Counts 0 to 49 for divide by 100

    // 50 MHz clock generation: toggle every clock cycle (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST)
            CLK_50 <= 1'b0;
        else
            CLK_50 <= ~CLK_50;
    end

    // 10 MHz clock generation: toggle every 5 clock cycles
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else if (cnt_10 == 3'd4) begin
            cnt_10 <= 3'd0;
            CLK_10 <= ~CLK_10;
        end else begin
            cnt_10 <= cnt_10 + 3'd1;
        end
    end

    // 1 MHz clock generation: toggle every 50 clock cycles
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 6'd0;
            CLK_1 <= 1'b0;
        end else if (cnt_100 == 6'd49) begin
            cnt_100 <= 6'd0;
            CLK_1 <= ~CLK_1;
        end else begin
            cnt_100 <= cnt_100 + 6'd1;
        end
    end

endmodule