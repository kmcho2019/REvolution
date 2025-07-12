module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Main counter (0-99)
    reg [6:0] main_counter;
    
    // Counter control
    always @(posedge CLK_in or posedge RST) begin
        if (RST) 
            main_counter <= 7'd0;
        else 
            main_counter <= (main_counter == 7'd99) ? 7'd0 : main_counter + 7'd1;
    end

    // Clock generation
    reg clk_50_reg, clk_10_reg, clk_1_reg;
    
    // 50MHz (toggle every cycle)
    assign CLK_50 = main_counter[0];
    
    // 10MHz (toggle every 5 cycles)
    assign CLK_10 = main_counter[2:0] == 3'b100;
    
    // 1MHz (toggle every 50 cycles)
    assign CLK_1 = main_counter == 7'd49;

endmodule