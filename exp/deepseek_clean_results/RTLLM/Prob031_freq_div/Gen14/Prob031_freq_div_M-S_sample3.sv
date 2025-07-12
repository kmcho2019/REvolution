module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // 50MHz clock - direct toggle
    reg clk50_reg;
    assign CLK_50 = clk50_reg;

    // Combined counter for both 10MHz and 1MHz
    reg [6:0] counter;  // Needs to count up to 99 (7 bits)

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            clk50_reg <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
            counter <= 0;
        end else begin
            // Toggle 50MHz clock every cycle
            clk50_reg <= ~clk50_reg;
            
            // Handle counter and slower clocks
            if (counter == 99) begin
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
            
            // Toggle 10MHz every 5 counts (0-4)
            if (counter == 4) begin
                CLK_10 <= ~CLK_10;
            end
            
            // Toggle 1MHz every 50 counts (0-49)
            if (counter == 49) begin
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule