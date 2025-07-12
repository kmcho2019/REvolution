module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,    // Active low reset
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         done      // Indicates multiplication complete
);

    // Internal registers
    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [15:0] partial_product;
    reg [3:0]  count;

    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_product <= 16'b0;
            multiplicand   <= 16'b0;
            multiplier     <= 8'b0;
            count          <= 4'd0;
            product        <= 16'b0;
            done           <= 1'b0;
            busy           <= 1'b0;
        end else begin
            if (!busy) begin
                // Start multiplication: load inputs and reset control signals
                partial_product <= 16'b0;
                multiplicand   <= {8'b0, A};  // zero-extend to 16 bits
                multiplier     <= B;
                count          <= 4'd8;       // 8 bits to process
                done           <= 1'b0;
                busy           <= 1'b1;
            end else if (count != 0) begin
                // Check LSB of multiplier to conditionally add multiplicand
                if (multiplier[0])
                    partial_product <= partial_product + multiplicand;
                // Shift multiplicand left by 1 (prepare for next bit)
                multiplicand <= multiplicand << 1;
                // Shift multiplier right by 1 to process next bit
                multiplier <= multiplier >> 1;
                count <= count - 1;
            end else begin
                // Multiplication complete
                product <= partial_product;
                done    <= 1'b1;
                busy    <= 1'b0; // Ready for next multiplication
            end
        end
    end

endmodule