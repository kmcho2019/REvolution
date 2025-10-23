module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready signal
);

    reg [4:0] ctr;                // 5-bit counter from 0 to 15
    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg [15:0] multiplier;           // sign-extended multiplier in 16 bits
    reg signed [15:0] multiplicand_shifted; // shifting multiplicand register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs and initialize registers
            multiplicand        <= { {8{a[7]}}, a };
            multiplier          <= { {8{b[7]}}, b };
            multiplicand_shifted <= { {8{a[7]}}, a };
            p                   <= 16'd0;
            ctr                 <= 5'd0;
            rdy                 <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // If current multiplier bit is 1, add multiplicand_shifted to product
                if (multiplier[ctr] == 1'b1) begin
                    // p is unsigned but multiplicand_shifted is signed - extend to signed sum
                    p <= p + multiplicand_shifted;
                end
                // Shift multiplicand_shifted left by 1 for next cycle
                multiplicand_shifted <= multiplicand_shifted <<< 1;
                // Increment counter
                ctr <= ctr + 1'b1;
                // Reset ready during operation
                rdy <= 1'b0;
            end else begin
                // Multiplication done
                rdy <= 1'b1;
            end
        end
    end

endmodule