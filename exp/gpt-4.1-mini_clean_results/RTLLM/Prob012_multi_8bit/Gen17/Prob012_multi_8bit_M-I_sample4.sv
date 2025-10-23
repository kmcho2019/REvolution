module multi_8bit (
    input  wire        clk,       // Clock input
    input  wire        rst_n,     // Active low reset
    input  wire        start,     // Start signal to begin multiplication
    input  wire [7:0]  A,         // Multiplicand
    input  wire [7:0]  B,         // Multiplier
    output reg  [15:0] product,   // Product output
    output reg         ready      // High when product is valid
);

    reg [15:0] multiplicand_reg;
    reg [7:0]  multiplier_reg;
    reg [3:0]  bit_index;         // Counts processed bits (0 to 8)
    reg [15:0] product_reg;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand_reg <= 16'd0;
            multiplier_reg   <= 8'd0;
            product_reg      <= 16'd0;
            bit_index        <= 4'd0;
            product          <= 16'd0;
            ready            <= 1'b0;
            busy             <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initialize for multiplication
                multiplicand_reg <= {8'd0, A}; // Zero-extend multiplicand to 16 bits
                multiplier_reg   <= B;
                product_reg      <= 16'd0;
                bit_index        <= 4'd0;
                busy             <= 1'b1;
                ready            <= 1'b0;
            end else if (busy) begin
                // Check current multiplier bit
                if (multiplier_reg[0]) begin
                    // Add multiplicand_reg to product_reg
                    product_reg <= product_reg + multiplicand_reg;
                end

                // Shift multiplicand left by 1
                multiplicand_reg <= multiplicand_reg << 1;

                // Shift multiplier right by 1
                multiplier_reg <= multiplier_reg >> 1;

                bit_index <= bit_index + 1;

                if (bit_index == 4'd7) begin
                    // Done after processing 8 bits
                    product <= product_reg;
                    ready <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                // Idle state, keep ready high if done
                ready <= ready;
                product <= product;
            end
        end
    end

endmodule