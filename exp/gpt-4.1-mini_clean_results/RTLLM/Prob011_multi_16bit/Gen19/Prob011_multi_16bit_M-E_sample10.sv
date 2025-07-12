module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [31:0] product;
    reg [4:0]  count;       // counts from 0 to 16
    reg        done_r;

    // Control and data path sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'b0;
            multiplier   <= 16'b0;
            product      <= 32'b0;
            count        <= 5'b0;
            done_r       <= 1'b0;
        end else begin
            if (!start) begin
                // Reset all when not started
                multiplicand <= 16'b0;
                multiplier   <= 16'b0;
                product      <= 32'b0;
                count        <= 5'b0;
                done_r       <= 1'b0;
            end else begin
                if (count == 0) begin
                    // Load inputs on start
                    multiplicand <= ain;
                    multiplier   <= bin;
                    product      <= 32'b0;
                    count        <= 5'd1;
                    done_r       <= 1'b0;
                end else if (count <= 16) begin
                    // If LSB of multiplier is 1, add shifted multiplicand to product
                    if (multiplier[0])
                        product <= product + ({16'b0, multiplicand});
                    else
                        product <= product;
                    // Shift multiplier right by 1 for next bit
                    multiplier <= multiplier >> 1;
                    count <= count + 5'd1;
                end else begin
                    // Multiplication done after 16 bits processed
                    done_r <= 1'b1;
                    count <= count; // hold count (optional: could reset on start low)
                end
            end
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule