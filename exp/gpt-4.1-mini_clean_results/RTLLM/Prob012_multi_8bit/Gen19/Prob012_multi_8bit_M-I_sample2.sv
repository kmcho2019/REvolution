module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,       // start signal to begin multiplication
    input  wire [7:0]  A,           // multiplicand
    input  wire [7:0]  B,           // multiplier
    output reg  [15:0] product,     // final product output
    output reg         done         // done signal goes high when multiplication completes
);

    // Internal registers
    reg [7:0]  multiplier;
    reg [15:0] multiplicand_shifted;
    reg [15:0] partial_product;
    reg [3:0]  count; // count 0 to 8 cycles

    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplier         <= 8'd0;
            multiplicand_shifted <= 16'd0;
            partial_product    <= 16'd0;
            count              <= 4'd0;
            product            <= 16'd0;
            done               <= 1'b0;
            busy               <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs and initialize registers at start
                multiplier          <= B;
                multiplicand_shifted <= {8'd0, A}; // zero-extend to 16 bits
                partial_product     <= 16'd0;
                count               <= 4'd0;
                done                <= 1'b0;
                busy                <= 1'b1;
            end else if (busy) begin
                // Iterative multiply shift-and-add
                if (multiplier[0])
                    partial_product <= partial_product + multiplicand_shifted;
                // Shift multiplicand left by 1 for next bit
                multiplicand_shifted <= multiplicand_shifted << 1;
                // Shift multiplier right by 1 to process next bit
                multiplier <= multiplier >> 1;
                count <= count + 1;

                if (count == 4'd7) begin
                    // All bits processed after 8 cycles
                    product <= partial_product;
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                // Idle, hold output and done
                done <= 1'b0;
            end
        end
    end

endmodule