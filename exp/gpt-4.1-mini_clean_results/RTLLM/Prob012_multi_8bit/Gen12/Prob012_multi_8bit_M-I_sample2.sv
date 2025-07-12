module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,       // Active low reset
    input  wire        start,       // Start signal to trigger multiplication
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         done         // High for one cycle when multiplication is complete
);

    reg [15:0] multiplicand_shifted; // Shifted multiplicand (A << i)
    reg [7:0]  multiplier_reg;       // Copy of B, shifted right during process
    reg [15:0] accumulator;          // Accumulated sum of partial products
    reg [3:0]  bit_cnt;              // Counts processed bits [0..7]
    reg        busy;                 // Indicates multiplication in progress

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product            <= 16'b0;
            done               <= 1'b0;
            multiplicand_shifted <= 16'b0;
            multiplier_reg     <= 8'b0;
            accumulator        <= 16'b0;
            bit_cnt            <= 4'd0;
            busy               <= 1'b0;
        end else begin
            done <= 1'b0; // Default done low each cycle

            if (start && !busy) begin
                // Initialize registers at start
                multiplicand_shifted <= {8'b0, A};  // Extend A to 16 bits
                multiplier_reg     <= B;
                accumulator        <= 16'b0;
                bit_cnt            <= 4'd0;
                busy               <= 1'b1;
            end else if (busy) begin
                // Process one bit of multiplier per cycle
                if (multiplier_reg[0]) begin
                    accumulator <= accumulator + multiplicand_shifted;
                end
                multiplicand_shifted <= multiplicand_shifted << 1;
                multiplier_reg <= multiplier_reg >> 1;
                bit_cnt <= bit_cnt + 1;

                if (bit_cnt == 4'd7) begin
                    product <= accumulator + (multiplier_reg[0] ? multiplicand_shifted : 16'b0);
                    busy <= 1'b0;
                    done <= 1'b1; // Signal that multiplication is complete this cycle
                end
            end
        end
    end

endmodule