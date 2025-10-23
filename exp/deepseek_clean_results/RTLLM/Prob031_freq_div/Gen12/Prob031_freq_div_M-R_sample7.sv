module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Unified counter (counts 0-99 for 100MHz->1MHz)
    reg [6:0] counter;
    
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'b0;
        end else begin
            if (counter == DIV_1 - 1)
                counter <= 7'b0;
            else
                counter <= counter + 1'b1;
        end
    end
    
    // Clock generation using bitwise comparisons
    assign CLK_50 = counter[0];  // Toggles every cycle (div by 2)
    assign CLK_10 = (counter % DIV_10) < (DIV_10/2);  // High for 5 cycles, low for 5
    assign CLK_1 = (counter % DIV_1) < (DIV_1/2);     // High for 50 cycles, low for 50
    
endmodule