module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,          // Start multiplication signal (pulse)
    input  wire [7:0]  A,              // Multiplicand
    input  wire [7:0]  B,              // Multiplier
    output reg  [15:0] product,        // Product output
    output reg         done            // Done signal indicates product valid
);

    // Internal registers
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] partial_product;
    reg [3:0] bit_count;     // Counts bits processed (0 to 8)
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product         <= 16'd0;
            partial_product <= 16'd0;
            multiplicand    <= 8'd0;
            multiplier      <= 8'd0;
            bit_count       <= 4'd0;
            done            <= 1'b0;
            busy            <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs and initialize
                multiplicand    <= A;
                multiplier      <= B;
                partial_product <= 16'd0;
                bit_count       <= 4'd0;
                done            <= 1'b0;
                busy            <= 1'b1;
            end else if (busy) begin
                // Multiply by shift and add method
                if (multiplier[0]) begin
                    partial_product <= partial_product + {8'd0, multiplicand};
                end
                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
                bit_count    <= bit_count + 1;

                if (bit_count == 4'd7) begin
                    // Multiplication done after 8 bits processed
                    product <= partial_product + (multiplier[0] ? {8'd0, multiplicand} : 16'd0);
                    done    <= 1'b1;
                    busy    <= 1'b0;
                end
            end else begin
                done <= 1'b0; // Clear done when not busy
            end
        end
    end

endmodule