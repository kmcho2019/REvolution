module multi_8bit (
    input            clk,      // Clock input
    input            rst_n,    // Active-low reset
    input            start,    // Start signal to begin multiplication
    input  [7:0]     A,        // Multiplicand
    input  [7:0]     B,        // Multiplier
    output reg [15:0] product, // Product output
    output reg       done      // Done signal when multiplication completes
);

    reg [7:0] multiplicand;  // Registers to hold inputs internally
    reg [7:0] multiplier;
    reg [15:0] acc;          // Accumulator for partial sums
    reg [3:0] bit_count;     // Counter for processed bits (0 to 8)

    reg busy;                // Busy flag indicating operation in progress

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product      <= 16'b0;
            done         <= 1'b0;
            multiplicand <= 8'b0;
            multiplier   <= 8'b0;
            acc          <= 16'b0;
            bit_count    <= 4'd0;
            busy         <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initialize registers to start multiplication
                multiplicand <= A;
                multiplier   <= B;
                acc          <= 16'b0;
                bit_count    <= 4'd0;
                busy         <= 1'b1;
                done         <= 1'b0;
            end else if (busy) begin
                if (multiplier[0]) begin
                    acc <= acc + {8'b0, multiplicand}; // Add shifted multiplicand
                end
                multiplicand <= multiplicand << 1; // Shift multiplicand left for next bit
                multiplier   <= multiplier >> 1;   // Shift multiplier right to process next bit
                bit_count    <= bit_count + 1;

                if (bit_count == 7) begin
                    product <= acc + ({8'b0, multiplicand} & {16{multiplier[0]}});
                    busy    <= 1'b0;
                    done    <= 1'b1;
                end
            end else begin
                done <= 1'b0; // Clear done signal when idle
            end
        end
    end

endmodule