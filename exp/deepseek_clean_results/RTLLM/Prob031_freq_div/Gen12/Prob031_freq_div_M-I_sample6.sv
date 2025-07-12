module freq_div (
    input CLK_in,
    input RST,
    output wire CLK_50,
    output wire CLK_10,
    output wire CLK_1
);

    // Division factors (precomputed constants)
    parameter DIV_50 = 1;      // 2^1 = 2 division
    parameter DIV_10 = 3;      // 2^3.32 ≈ 10 division (using bit 3)
    parameter DIV_1 = 6;       // 2^6.64 ≈ 100 division (using bit 6)
    
    // Shared Gray code counter
    reg [6:0] gray_counter;
    wire [6:0] next_gray;
    
    // Binary conversion for comparison
    wire [6:0] bin_counter;
    
    // Gray to binary conversion
    assign bin_counter[6] = gray_counter[6];
    assign bin_counter[5] = gray_counter[5] ^ bin_counter[6];
    assign bin_counter[4] = gray_counter[4] ^ bin_counter[5];
    assign bin_counter[3] = gray_counter[3] ^ bin_counter[4];
    assign bin_counter[2] = gray_counter[2] ^ bin_counter[3];
    assign bin_counter[1] = gray_counter[1] ^ bin_counter[2];
    assign bin_counter[0] = gray_counter[0] ^ bin_counter[1];
    
    // Next Gray code value (increment and convert to Gray)
    wire [6:0] next_bin = bin_counter + 1;
    assign next_gray = (next_bin >> 1) ^ next_bin;
    
    // Counter update
    always @(posedge CLK_in or posedge RST) begin
        if (RST) gray_counter <= 7'b0;
        else gray_counter <= next_gray;
    end
    
    // Clock generation
    assign CLK_50 = gray_counter[DIV_50];
    assign CLK_10 = gray_counter[DIV_10];
    assign CLK_1 = gray_counter[DIV_1];

endmodule