module freq_div (
    input wire CLK_in,
    input wire RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Parameters for division factors
    parameter DIV_50 = 2;
    parameter DIV_10 = 10;
    parameter DIV_1 = 100;
    
    // Counter width (7 bits can count up to 127)
    localparam COUNTER_WIDTH = 7;
    
    // Gray code counter
    reg [COUNTER_WIDTH-1:0] counter;
    wire [COUNTER_WIDTH-1:0] next_counter;
    wire [COUNTER_WIDTH-1:0] binary_counter;
    
    // Clock enables
    reg en_50, en_10, en_1;
    
    // Output clock registers
    reg clk_50_reg, clk_10_reg, clk_1_reg;
    
    // Binary to Gray conversion
    function [COUNTER_WIDTH-1:0] bin2gray;
        input [COUNTER_WIDTH-1:0] bin;
        begin
            bin2gray = bin ^ (bin >> 1);
        end
    endfunction
    
    // Gray to Binary conversion
    function [COUNTER_WIDTH-1:0] gray2bin;
        input [COUNTER_WIDTH-1:0] gray;
        integer i;
        begin
            gray2bin[COUNTER_WIDTH-1] = gray[COUNTER_WIDTH-1];
            for (i = COUNTER_WIDTH-2; i >= 0; i = i - 1)
                gray2bin[i] = gray2bin[i+1] ^ gray[i];
        end
    endfunction
    
    // Convert counter to binary for comparison
    assign binary_counter = gray2bin(counter);
    
    // Next counter value (binary increment then convert to Gray)
    assign next_counter = bin2gray(binary_counter + 1'b1);
    
    // Main counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            counter <= bin2gray(0);
            clk_50_reg <= 1'b0;
            clk_10_reg <= 1'b0;
            clk_1_reg <= 1'b0;
        end else begin
            counter <= next_counter;
            
            // Clock enable generation
            en_50 <= (binary_counter[0] == 1'b0);  // Every other cycle
            en_10 <= (binary_counter[3:0] == 4'b1000);  // Every 10 cycles
            en_1 <= (binary_counter == 7'b1100011);  // Every 100 cycles (99 in binary)
            
            // Clock generation with enables
            if (en_50) clk_50_reg <= ~clk_50_reg;
            if (en_10) clk_10_reg <= ~clk_10_reg;
            if (en_1) clk_1_reg <= ~clk_1_reg;
        end
    end
    
    // Clock gating cells for power optimization
    BUFGCE clk50_buf (
        .I(clk_50_reg),
        .CE(en_50),
        .O(CLK_50)
    );
    
    BUFGCE clk10_buf (
        .I(clk_10_reg),
        .CE(en_10),
        .O(CLK_10)
    );
    
    BUFGCE clk1_buf (
        .I(clk_1_reg),
        .CE(en_1),
        .O(CLK_1)
    );

endmodule