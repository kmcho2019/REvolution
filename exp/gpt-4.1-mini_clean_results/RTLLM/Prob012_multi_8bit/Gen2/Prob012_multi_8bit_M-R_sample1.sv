module multi_8bit (
    input             clk,
    input             rst_n,
    input             start,
    input      [7:0]  A,       // multiplicand
    input      [7:0]  B,       // multiplier
    output reg [15:0] product,
    output reg        done
);

    reg [15:0] multiplicand_shifted; // shifted multiplicand for addition
    reg [7:0]  multiplier_reg;       // copy of multiplier, shifted right each cycle
    reg [3:0]  count;                // count from 0 to 8 for bits processed
    reg [15:0] sum;                  // accumulator for partial sums
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum                <= 16'd0;
            multiplicand_shifted <= 16'd0;
            multiplier_reg     <= 8'd0;
            count              <= 4'd0;
            product            <= 16'd0;
            done               <= 1'b0;
            busy               <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initialize registers on start
                sum                <= 16'd0;
                multiplicand_shifted <= {8'd0, A};
                multiplier_reg     <= B;
                count              <= 4'd0;
                done               <= 1'b0;
                busy               <= 1'b1;
            end else if (busy) begin
                if (multiplier_reg[0]) begin
                    sum <= sum + multiplicand_shifted;
                end
                multiplicand_shifted <= multiplicand_shifted << 1;
                multiplier_reg <= multiplier_reg >> 1;
                count <= count + 1;

                if (count == 4'd7) begin
                    product <= sum + (multiplier_reg[0] ? multiplicand_shifted : 16'd0);
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                // idle state, hold done until start
                done <= done;
                product <= product;
            end
        end
    end

endmodule