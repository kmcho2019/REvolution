module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         done
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accum;
    reg [3:0] bit_cnt;
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 8'b0;
            multiplier   <= 8'b0;
            accum        <= 16'b0;
            bit_cnt      <= 4'd0;
            product      <= 16'b0;
            done         <= 1'b0;
            busy         <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initialize registers on start
                multiplicand <= A;
                multiplier   <= B;
                accum        <= 16'b0;
                bit_cnt      <= 4'd0;
                done         <= 1'b0;
                busy         <= 1'b1;
            end else if (busy) begin
                // If current multiplier bit is 1, add shifted multiplicand
                if (multiplier[0] == 1'b1)
                    accum <= accum + {8'b0, multiplicand};
                else
                    accum <= accum;

                // Shift multiplicand left by 1 for next bit
                multiplicand <= multiplicand << 1;
                // Shift multiplier right by 1 to move to next bit
                multiplier <= multiplier >> 1;

                // Increment bit counter
                bit_cnt <= bit_cnt + 1;

                if (bit_cnt == 7) begin
                    product <= accum + ((multiplier[0]) ? {8'b0, multiplicand} : 16'b0);
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                done <= 1'b0;
            end
        end
    end

endmodule