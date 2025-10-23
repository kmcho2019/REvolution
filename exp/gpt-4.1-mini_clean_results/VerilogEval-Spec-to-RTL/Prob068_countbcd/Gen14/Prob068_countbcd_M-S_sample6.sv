module TopModule (
    input         clk,
    input         reset,
    output [2:0]  ena,
    output [15:0] q
);

    reg [15:0] q_reg;
    wire [3:0] digits[3:0];

    // Extract individual digits from q_reg
    assign digits[0] = q_reg[3:0];     // ones
    assign digits[1] = q_reg[7:4];     // tens
    assign digits[2] = q_reg[11:8];    // hundreds
    assign digits[3] = q_reg[15:12];   // thousands

    // Generate enable signals when each digit rolls over from 9 to 0
    assign ena[0] = (digits[0] == 4'd9);
    assign ena[1] = ena[0] && (digits[1] == 4'd9);
    assign ena[2] = ena[1] && (digits[2] == 4'd9);

    always @(posedge clk) begin
        if (reset) begin
            q_reg <= 16'd0;
        end else begin
            // Increment ones digit
            if (digits[0] == 4'd9) begin
                // Ones digit rolls over
                // Increment tens digit
                if (digits[1] == 4'd9) begin
                    // Tens digit rolls over
                    if (digits[2] == 4'd9) begin
                        // Hundreds digit rolls over
                        if (digits[3] == 4'd9) begin
                            // Thousands digit rolls over -> wrap all digits
                            q_reg <= 16'd0;
                        end else begin
                            // Increment thousands, reset others
                            q_reg <= { (digits[3] + 4'd1), 12'd0 };
                        end
                    end else begin
                        // Increment hundreds, reset tens and ones
                        q_reg <= { digits[3], (digits[2] + 4'd1), 8'd0 };
                    end
                end else begin
                    // Increment tens, reset ones
                    q_reg <= { digits[3], digits[2], (digits[1] + 4'd1), 4'd0 };
                end
            end else begin
                // Just increment ones digit
                q_reg <= q_reg + 16'd1;
            end
        end
    end

    assign q = q_reg;

endmodule