module multi_8bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [7:0]    A,
    input  [7:0]    B,
    output reg [15:0] product,
    output reg      done
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [3:0]  bit_count;
    reg [15:0] acc;

    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product     <= 16'd0;
            acc         <= 16'd0;
            multiplicand<= 16'd0;
            multiplier  <= 8'd0;
            bit_count   <= 4'd0;
            busy        <= 1'b0;
            done        <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs and start multiplication
                multiplicand <= {8'd0, A};
                multiplier   <= B;
                acc          <= 16'd0;
                bit_count    <= 4'd0;
                busy         <= 1'b1;
                done         <= 1'b0;
            end else if (busy) begin
                // Check the LSB of multiplier; if 1 add multiplicand to acc
                if (multiplier[0])
                    acc <= acc + multiplicand;

                // Shift multiplicand left by 1 for next bit
                multiplicand <= multiplicand << 1;

                // Shift multiplier right by 1 to process next bit
                multiplier <= multiplier >> 1;

                bit_count <= bit_count + 1;

                if (bit_count == 4'd7) begin
                    // Multiplication done
                    product <= acc;
                    busy <= 1'b0;
                    done <= 1'b1;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule