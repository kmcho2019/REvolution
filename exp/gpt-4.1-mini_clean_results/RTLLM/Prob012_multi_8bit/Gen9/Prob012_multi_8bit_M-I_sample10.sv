module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,    // active low reset
    input  wire        start,    // start multiplication
    input  wire [7:0]  A,        // multiplicand
    input  wire [7:0]  B,        // multiplier
    output reg  [15:0] product,  // product output
    output reg         done      // done flag
);

    // Internal registers
    reg [15:0] product_reg;
    reg [7:0]  multiplicand_reg;
    reg [7:0]  multiplier_reg;
    reg [3:0]  bit_index;  // 0 to 7 for bits of B
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg      <= 16'd0;
            multiplicand_reg <= 8'd0;
            multiplier_reg   <= 8'd0;
            bit_index        <= 4'd0;
            busy             <= 1'b0;
            product          <= 16'd0;
            done             <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Start new multiplication
                product_reg      <= 16'd0;
                multiplicand_reg <= {8'd0, A}; // Zero extend A to 16 bits
                multiplier_reg   <= B;
                bit_index        <= 4'd0;
                busy             <= 1'b1;
                done             <= 1'b0;
            end else if (busy) begin
                // If current multiplier bit is 1, add shifted multiplicand
                if (multiplier_reg[0] == 1'b1)
                    product_reg <= product_reg + (multiplicand_reg << bit_index);
                bit_index      <= bit_index + 1'b1;
                multiplier_reg <= multiplier_reg >> 1;

                if (bit_index == 4'd7) begin
                    // Last bit processed
                    product <= product_reg + ((multiplier_reg[0] == 1'b1) ? (multiplicand_reg << bit_index) : 16'd0);
                    busy    <= 1'b0;
                    done    <= 1'b1;
                end
            end else begin
                // Idle, maintain outputs
                done <= 1'b0;
            end
        end
    end

endmodule