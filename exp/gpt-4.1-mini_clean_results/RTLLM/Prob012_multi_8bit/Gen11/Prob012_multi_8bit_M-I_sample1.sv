module multi_8bit (
    input  wire        clk,       // Clock input for sequential operation
    input  wire        rst_n,     // Active low synchronous reset
    input  wire        start,     // Start signal to begin multiplication
    input  wire [7:0]  A,         // Multiplicand
    input  wire [7:0]  B,         // Multiplier
    output reg  [15:0] product,   // Product output
    output reg         done       // Done flag indicating multiplication completion
);

    reg [7:0] multiplier;
    reg [15:0] multiplicand;
    reg [3:0] bit_idx; // Index for bits of multiplier (0 to 7)
    reg [15:0] partial_sum;

    always @(posedge clk) begin
        if (!rst_n) begin
            product      <= 16'b0;
            done         <= 1'b0;
            bit_idx      <= 4'd0;
            partial_sum  <= 16'b0;
            multiplier   <= 8'b0;
            multiplicand <= 16'b0;
        end else begin
            if (start && !done) begin
                // Initialization at start
                if (bit_idx == 0) begin
                    partial_sum  <= 16'b0;
                    multiplier   <= B;
                    multiplicand <= {8'b0, A};
                    done         <= 1'b0;
                end

                // Perform shift-and-add for the current bit
                if (multiplier[0]) begin
                    partial_sum <= partial_sum + multiplicand;
                end

                // Shift multiplicand left by 1 and multiplier right by 1
                multiplicand <= multiplicand << 1;
                multiplier <= multiplier >> 1;

                // Increment bit index
                bit_idx <= bit_idx + 1;

                // After processing all bits
                if (bit_idx == 7) begin
                    product <= partial_sum + (multiplier[0] ? multiplicand : 16'b0);
                    done <= 1'b1;
                end
            end else if (!start) begin
                // Reset done flag and bit index when not started
                done <= 1'b0;
                bit_idx <= 0;
            end
        end
    end

endmodule