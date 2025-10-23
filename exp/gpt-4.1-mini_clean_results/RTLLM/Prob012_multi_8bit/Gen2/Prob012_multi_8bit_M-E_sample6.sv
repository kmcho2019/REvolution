module multi_8bit (
    input              clk,
    input              rst_n,
    input              start,
    input      [7:0]   A,
    input      [7:0]   B,
    output reg [15:0]  product,
    output reg         done
);

    reg [15:0] multiplicand;
    reg [7:0]  multiplier;
    reg [15:0] accumulator;
    reg [3:0]  count;
    reg        working;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product      <= 16'b0;
            multiplicand <= 16'b0;
            multiplier   <= 8'b0;
            accumulator  <= 16'b0;
            count        <= 4'd0;
            done         <= 1'b0;
            working      <= 1'b0;
        end else begin
            if (start && !working) begin
                // Load inputs and initialize
                multiplicand <= {8'b0, A};
                multiplier   <= B;
                accumulator  <= 16'b0;
                count        <= 4'd0;
                done         <= 1'b0;
                working      <= 1'b1;
            end else if (working) begin
                if (multiplier[0]) begin
                    accumulator <= accumulator + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
                count       <= count + 1'b1;

                if (count == 4'd7) begin
                    product <= accumulator;
                    done    <= 1'b1;
                    working <= 1'b0;
                end
            end else begin
                done <= 1'b0; // Clear done when idle
            end
        end
    end

endmodule