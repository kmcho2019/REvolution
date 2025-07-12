module multi_8bit (
    input          clk,
    input          rst_n,
    input          start,
    input   [7:0]  A,
    input   [7:0]  B,
    output  reg [15:0] product,
    output  reg     done
);
    reg [15:0] multiplicand_shifted;
    reg [7:0]  multiplier;
    reg [3:0]  bit_index; // to count from 0 to 7
    reg [15:0] accumulator;
    reg        running;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product          <= 16'd0;
            done             <= 1'b0;
            multiplier       <= 8'd0;
            multiplicand_shifted <= 16'd0;
            bit_index        <= 4'd0;
            accumulator      <= 16'd0;
            running          <= 1'b0;
        end else begin
            if (start && !running) begin
                // Initialize for multiplication
                multiplier          <= B;
                multiplicand_shifted <= {8'd0, A}; // 16-bit aligned
                accumulator         <= 16'd0;
                bit_index           <= 4'd0;
                done                <= 1'b0;
                running             <= 1'b1;
            end else if (running) begin
                // For current bit of multiplier, if set add shifted multiplicand to accumulator
                if (multiplier[0]) begin
                    accumulator <= accumulator + multiplicand_shifted;
                end
                // Shift multiplicand left by 1 for next bit
                multiplicand_shifted <= multiplicand_shifted << 1;
                // Shift multiplier right by 1 to process next bit
                multiplier <= multiplier >> 1;
                bit_index <= bit_index + 1;
                if (bit_index == 4'd7) begin
                    product <= accumulator;
                    done    <= 1'b1;
                    running <= 1'b0;
                end
            end else begin
                done <= 1'b0; // clear done when idle
            end
        end
    end

endmodule