module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter width (precisely sized for 0-99)
    localparam MAIN_CNT_WIDTH = 7;  // counts 0-99 (100 cycles)

    // Main counter
    reg [MAIN_CNT_WIDTH-1:0] main_cnt;

    // CLK_50 generation (divide by 2)
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
        end else begin
            CLK_50 <= ~CLK_50;
        end
    end

    // CLK_10 and CLK_1 generation with single counter
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            main_cnt <= 0;
        end else begin
            // Increment main counter
            if (main_cnt == 99) begin
                main_cnt <= 0;
            end else begin
                main_cnt <= main_cnt + 1'b1;
            end
            
            // Toggle CLK_10 at count 4 (every 5 cycles)
            if (main_cnt == 4) begin
                CLK_10 <= ~CLK_10;
            end
            
            // Toggle CLK_1 at count 49 (every 50 cycles)
            if (main_cnt == 49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule