module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Division parameters
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;

    // Counter registers
    reg [6:0] counter;  // Need 7 bits to count up to 100

    // CLK_50 generation - pure combinational
    reg clk_50_reg;
    assign CLK_50 = clk_50_reg;

    // Counter and clock generation logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 0;
            clk_50_reg <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else begin
            // Update main counter
            counter <= (counter == DIV_1-1) ? 0 : counter + 1;

            // Toggle CLK_50 every cycle (div by 2)
            clk_50_reg <= ~clk_50_reg;

            // Toggle CLK_10 every DIV_10/2 counts (div by 10)
            if (counter % (DIV_10/2) == (DIV_10/2)-1) begin
                CLK_10 <= ~CLK_10;
            end

            // Toggle CLK_1 every DIV_1/2 counts (div by 100)
            if (counter == (DIV_1/2)-1) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule