module multi_16bit (
    input          clk,
    input          rst_n,     // Active-low synchronous reset
    input          start,
    input  [15:0]  ain,       // Multiplicand
    input  [15:0]  bin,       // Multiplier
    output reg [31:0] yout,   // Product output
    output reg     done
);

    reg [4:0] count;           // Counts 0 to 16 (16 cycles)
    reg [31:0] product;        // Accumulated product
    reg busy;                  // Busy flag
    reg [15:0] multiplier_reg; // Latched multiplier
    reg [15:0] multiplicand_reg; // Latched multiplicand

    // Calculate shifted multiplicand based on current count:
    wire [31:0] shifted_multiplicand = {{16{1'b0}}, multiplicand_reg} << count;

    always @(posedge clk) begin
        if (!rst_n) begin
            count          <= 5'd0;
            product        <= 32'd0;
            yout           <= 32'd0;
            done           <= 1'b0;
            busy           <= 1'b0;
            multiplier_reg <= 16'd0;
            multiplicand_reg <= 16'd0;
        end else begin
            if (start && !busy) begin
                // Start multiplication: latch inputs and initialize
                busy            <= 1'b1;
                count           <= 5'd0;
                product         <= 32'd0;
                done            <= 1'b0;
                multiplier_reg  <= bin;
                multiplicand_reg <= ain;
            end else if (busy) begin
                // During multiplication:
                if (count < 5'd16) begin
                    // If current multiplier bit is set, accumulate shifted multiplicand
                    if (multiplier_reg[count])
                        product <= product + shifted_multiplicand;
                    else
                        product <= product;
                    count <= count + 5'd1;
                end else begin
                    // Completed all bits
                    yout <= product;
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                // Idle: hold done and yout stable
                done <= done;
                yout <= yout;
            end
        end
    end

endmodule