module freq_div (
    input  wire CLK_in,    // 100 MHz input clock
    input  wire RST,       // synchronous active high reset
    output reg  CLK_50,    // 50 MHz output clock (divide by 2)
    output reg  CLK_10,    // 10 MHz output clock (divide by 10)
    output reg  CLK_1      // 1 MHz output clock (divide by 100)
);

    // Localparams for count limits (half of divide factor - 1)
    localparam CNT_50_MAX  = 1;  // toggle CLK_50 every 1 cycle (divide by 2)
    localparam CNT_10_MAX  = 4;  // toggle CLK_10 every 5 cycles (divide by 10)
    localparam CNT_1_MAX   = 4;  // toggle CLK_1 every 5 cycles on 10 MHz clock (divide by 10)

    // Counters for frequency division
    reg [0:0]  cnt_50;   // 1 bit enough for count to 1
    reg [2:0]  cnt_10;   // 3 bits enough for count to 4
    reg [2:0]  cnt_1;    // 3 bits enough for count to 4

    // Intermediate wire for 10 MHz clock to feed 1 MHz divider
    // Implement hierarchical division: 100 MHz -> 10 MHz -> 1 MHz

    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_50 <= 1'b0;
            CLK_50 <= 1'b0;
        end else begin
            if (cnt_50 == CNT_50_MAX) begin
                cnt_50 <= 1'b0;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_50 <= cnt_50 + 1'b1;
            end
        end
    end

    // Generate 10 MHz clock from 100 MHz input clock
    always @(posedge CLK_in) begin
        if (RST) begin
            cnt_10 <= 3'd0;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == CNT_10_MAX) begin
                cnt_10 <= 3'd0;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 1'b1;
            end
        end
    end

    // Generate 1 MHz clock from 10 MHz clock (hierarchical division)
    always @(posedge CLK_10) begin
        if (RST) begin
            cnt_1 <= 3'd0;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_1 == CNT_1_MAX) begin
                cnt_1 <= 3'd0;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_1 <= cnt_1 + 1'b1;
            end
        end
    end

endmodule