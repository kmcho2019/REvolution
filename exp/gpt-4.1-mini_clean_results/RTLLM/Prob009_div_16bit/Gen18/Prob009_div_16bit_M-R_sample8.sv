module div_16bit (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         start,   // start signal to begin division
    input  wire [15:0]  A,       // Dividend
    input  wire [7:0]   B,       // Divisor
    output reg  [15:0]  result,  // Quotient
    output reg  [15:0]  odd,     // Remainder (lower 8 bits valid)
    output reg          done     // Indicates division completion
);

    reg [15:0] a_reg;      // Dividend register
    reg [7:0]  b_reg;      // Divisor register

    reg [8:0]  remainder;  // 9-bit remainder to hold remainder + next bit
    reg [4:0]  count;      // Iteration counter (0 to 16)
    reg [15:0] quotient;   // Quotient being built

    reg        busy;       // Division in progress flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg     <= 16'd0;
            b_reg     <= 8'd0;
            remainder <= 9'd0;
            quotient  <= 16'd0;
            count     <= 5'd0;
            result    <= 16'd0;
            odd       <= 16'd0;
            done      <= 1'b0;
            busy      <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs and initialize division
                a_reg     <= A;
                b_reg     <= B;
                remainder <= 9'd0;
                quotient  <= 16'd0;
                count     <= 5'd0;
                done      <= 1'b0;
                busy      <= 1'b1;
            end else if (busy) begin
                // Shift remainder left by 1, append next dividend bit (from MSB)
                remainder <= {remainder[7:0], a_reg[15 - count]};

                // Compare remainder and divisor
                if ({1'b0, remainder[7:0], a_reg[15 - count]} >= {1'b0, b_reg}) begin
                    remainder <= ({remainder[7:0], a_reg[15 - count]} - {1'b0, b_reg});
                    quotient  <= quotient | (16'd1 << (15 - count));
                end

                count <= count + 1;

                if (count == 5'd15) begin
                    // Last iteration done
                    done   <= 1'b1;
                    busy   <= 1'b0;
                    result <= quotient;
                    odd    <= {8'd0, remainder[7:0]}; // zero-extend remainder
                end
            end else begin
                done <= 1'b0; // clear done when not busy or starting
            end
        end
    end

endmodule