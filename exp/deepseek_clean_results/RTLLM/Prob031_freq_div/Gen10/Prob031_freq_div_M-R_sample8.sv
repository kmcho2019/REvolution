module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Unified counter for all clock divisions
    reg [6:0] counter;  // Needs to count up to 99 (for 1MHz)
    
    // Clock generation using assign statements
    assign CLK_50 = counter[0];  // Toggles every cycle (div by 2)
    assign CLK_10 = counter[3];  // Toggles every 5 cycles (div by 10)
    assign CLK_1 = counter[6];   // Toggles every 50 cycles (div by 100)

    // Counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= 7'b0;
        end else begin
            if (counter == DIV_1-1) begin
                counter <= 7'b0;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule