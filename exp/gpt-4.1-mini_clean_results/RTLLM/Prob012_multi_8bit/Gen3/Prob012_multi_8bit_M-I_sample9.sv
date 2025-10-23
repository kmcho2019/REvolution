module multi_8bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [7:0]    A,
    input  [7:0]    B,
    output reg [15:0] product,
    output reg      done
);

    reg [15:0] multiplicand_shifted;
    reg [7:0]  multiplier;
    reg [3:0]  bit_count;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product           <= 16'd0;
            multiplicand_shifted <= 16'd0;
            multiplier        <= 8'd0;
            bit_count         <= 4'd0;
            busy              <= 1'b0;
            done              <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initialize registers at start of multiplication
                product           <= 16'd0;
                multiplicand_shifted <= {8'd0, A}; // Extend A to 16 bits
                multiplier        <= B;
                bit_count         <= 4'd0;
                busy              <= 1'b1;
                done              <= 1'b0;
            end else if (busy) begin
                // For each bit of multiplier, add shifted multiplicand if bit is set
                if (multiplier[0] == 1'b1)
                    product <= product + multiplicand_shifted;

                // Shift multiplicand left by 1
                multiplicand_shifted <= multiplicand_shifted << 1;

                // Shift multiplier right by 1
                multiplier <= multiplier >> 1;

                bit_count <= bit_count + 1;

                if (bit_count == 7) begin
                    busy <= 1'b0;
                    done <= 1'b1;
                end
            end else begin
                done <= 1'b0; // Clear done flag until next start
            end
        end
    end

endmodule