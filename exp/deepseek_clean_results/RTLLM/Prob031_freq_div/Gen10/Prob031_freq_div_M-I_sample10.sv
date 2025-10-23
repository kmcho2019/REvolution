module freq_div (
    input CLK_in,
    input RST,
    input EN_50,  // Enable for 50MHz output
    input EN_10,  // Enable for 10MHz output
    input EN_1,   // Enable for 1MHz output
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    // Precomputed division constants
    localparam DIV_50 = 2;
    localparam DIV_10 = 10;
    localparam DIV_1 = 100;
    localparam DIV_50_HALF = DIV_50/2 - 1;
    localparam DIV_10_HALF = DIV_10/2 - 1;
    localparam DIV_1_HALF = DIV_1/2 - 1;

    // Shared Gray code counter (7 bits for counting to 49)
    reg [6:0] gray_counter;
    wire [6:0] gray_next = gray_counter ^ {1'b0, gray_counter[6:1]};
    wire [6:0] bin_counter;
    
    // Gray to binary conversion
    genvar i;
    generate
        for (i = 0; i < 7; i = i + 1) begin : gray2bin
            assign bin_counter[i] = ^(gray_counter >> i);
        end
    endgenerate

    // Main counter logic
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            gray_counter <= 7'b0;
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
        end else begin
            // Update Gray counter
            gray_counter <= (bin_counter == DIV_1_HALF) ? 7'b0 : gray_next;
            
            // CLK_50 generation (toggle every DIV_50/2 counts)
            if (EN_50 && (bin_counter[0] == 1'b1)) 
                CLK_50 <= ~CLK_50;
            
            // CLK_10 generation (toggle every DIV_10/2 counts)
            if (EN_10 && (bin_counter[3:0] == DIV_10_HALF[3:0]))
                CLK_10 <= ~CLK_10;
            
            // CLK_1 generation (toggle every DIV_1/2 counts)
            if (EN_1 && (bin_counter == DIV_1_HALF))
                CLK_1 <= ~CLK_1;
        end
    end

endmodule