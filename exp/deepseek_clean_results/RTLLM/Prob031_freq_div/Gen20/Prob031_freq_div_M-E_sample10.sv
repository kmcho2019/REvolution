module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division parameters
    parameter DIV_50 = 2;     // 100MHz / 2 = 50MHz
    parameter DIV_10 = 10;    // 100MHz / 10 = 10MHz
    parameter DIV_1 = 100;    // 100MHz / 100 = 1MHz

    // Shared counter width (covers largest division)
    localparam CNT_WIDTH = $clog2(DIV_1);
    reg [CNT_WIDTH-1:0] counter;
    wire [CNT_WIDTH-1:0] counter_gray;
    
    // Convert binary counter to gray code for low power
    assign counter_gray = counter ^ (counter >> 1);

    // Clock enable signals
    wire clk_50_en = 1'b1;  // Always enabled (toggle every cycle)
    wire clk_10_en = (counter_gray % DIV_10 == DIV_10/2-1);
    wire clk_1_en = (counter_gray % DIV_1 == DIV_1/2-1);

    // Shared counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    // CLK_50 generation (toggle every cycle)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else if (clk_50_en) begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 generation (toggle every 5 cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
        end else if (clk_10_en) begin
            CLK_10 <= ~CLK_10;
        end
    end

    // CLK_1 generation (toggle every 50 cycles)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_1 <= 1'b0;
        end else if (clk_1_en) begin
            CLK_1 <= ~CLK_1;
        end
    end

endmodule