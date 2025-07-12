module freq_div (
    input  wire CLK_in,
    input  wire RST,
    output reg  CLK_50,
    output reg  CLK_10,
    output reg  CLK_1
);

    // Counters for 10 MHz and 1 MHz clocks
    reg [2:0] cnt_10;
    reg [5:0] cnt_100;

    // CLK_50 generation: toggle every clock cycle
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation: toggle every 5 clock cycles
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            cnt_10 <= 3'd0;
        end else if (cnt_10 == 3'd4) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 3'd0;
        end else begin
            cnt_10 <= cnt_10 + 1'b1;
        end
    end

    // CLK_1 generation: toggle every 50 clock cycles
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
            cnt_100 <= 6'd0;
        end else if (cnt_100 == 6'd49) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 6'd0;
        end else begin
            cnt_100 <= cnt_100 + 1'b1;
        end
    end

endmodule