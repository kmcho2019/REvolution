module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [1:0] counter;  // 4 steps for Radix-4 (8-bit)
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extended with sign bit
    reg [15:0] product;

    // Booth encoding and partial product selection
    wire [15:0] partial_product;
    assign partial_product = 
        (multiplier[1:0] == 2'b00 || multiplier[1:0] == 2'b11) ? 16'b0 :
        (multiplier[1:0] == 2'b01) ? multiplicand :
        (multiplier[1:0] == 2'b10) ? ~multiplicand + 1'b1 :  // -M
        {multiplicand[14:0], 1'b0};  // 2*M

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers with sign-extended inputs
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b[7], b};
            product <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            if (counter < 2'b11) begin
                // Accumulate partial product
                product <= product + partial_product;
                
                // Arithmetic shift right by 2 bits
                multiplicand <= multiplicand << 2;
                multiplier <= multiplier >> 2;
                
                counter <= counter + 1;
                rdy <= 1'b0;
            end else begin
                // Final cycle - output result
                p <= product + partial_product;
                rdy <= 1'b1;
            end
        end
    end

endmodule