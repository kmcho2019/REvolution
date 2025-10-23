module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         done
);

    reg [15:0] multiplicand_shifted; // Shifted multiplicand accumulator
    reg [7:0]  multiplier_reg;       // Shifted multiplier
    reg [15:0] product_accum;        // Partial product accumulator
    reg [3:0]  count;                // Bit position counter

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_accum      <= 16'd0;
            multiplicand_shifted <= 16'd0;
            multiplier_reg     <= 8'd0;
            count              <= 4'd0;
            done               <= 1'b0;
            product            <= 16'd0;
        end else begin
            if (start && !done) begin
                // Initialization on start
                product_accum      <= 16'd0;
                multiplicand_shifted <= {8'd0, A}; // Extend to 16 bits
                multiplier_reg     <= B;
                count              <= 4'd8;
                done               <= 1'b0;
                product            <= 16'd0;
            end else if (count != 0) begin
                // Shift-and-add multiplication steps
                if (multiplier_reg[0] == 1'b1) begin
                    product_accum <= product_accum + multiplicand_shifted;
                end
                multiplicand_shifted <= multiplicand_shifted << 1;
                multiplier_reg <= multiplier_reg >> 1;
                count <= count - 1;
                if (count == 1) begin
                    done <= 1'b1;
                    product <= product_accum + (multiplier_reg[0] ? multiplicand_shifted : 16'd0);
                end
            end else begin
                // Hold done and product stable until next start
                done <= done;
                product <= product;
            end
        end
    end

endmodule