module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Shared counter parameters
    parameter MAIN_COUNTER_WIDTH = 7; // Enough for 100 divisions (2^7=128)
    reg [MAIN_COUNTER_WIDTH-1:0] main_counter;

    // Clock enable signals
    wire clk_50_en;
    wire clk_10_en;
    wire clk_1_en;

    // Terminal counts
    localparam TC_50 = 0; // Toggle every cycle (div by 2)
    localparam TC_10 = 4; // (10/2)-1
    localparam TC_1 = 49; // (100/2)-1

    // Main counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            main_counter <= 0;
        end else begin
            if (main_counter == TC_1) begin
                main_counter <= 0;
            end else begin
                main_counter <= main_counter + 1;
            end
        end
    end

    // Clock enable generation
    assign clk_50_en = 1'b1; // Always toggle for div by 2
    assign clk_10_en = (main_counter == TC_10);
    assign clk_1_en = (main_counter == TC_1);

    // Output clock generation
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // CLK_50 - divide by 2
            if (clk_50_en) CLK_50 <= ~CLK_50;
            
            // CLK_10 - divide by 10
            if (clk_10_en) CLK_10 <= ~CLK_10;
            
            // CLK_1 - divide by 100
            if (clk_1_en) CLK_1 <= ~CLK_1;
        end
    end

endmodule