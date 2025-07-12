module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,      // multiplicand
    input   [7:0]   b,      // multiplier
    output reg [15:0] p,    // product output
    output reg      rdy      // ready flag
);

    // Internal registers
    reg signed [16:0] multiplicand;  // sign-extended multiplicand (8 + 9 bits)
    reg [17:0] multiplier;            // multiplier with appended zero bit (8 + 1 bits)
    reg signed [33:0] product;        // enough bits to hold partial sums (17 + 17)
    reg [2:0] count;                  // cycle counter (0 to 4 for 4 cycles)

    // Declare these here (fixing illegal declarations inside always)
    reg signed [2:0] factor;
    reg signed [33:0] partial;

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= { {9{a[7]}}, a };       // sign extend 8-bit multiplicand to 17 bits
            multiplier   <= {b, 1'b0};               // append zero LSB bit for Booth encoding (9 bits)
            product      <= 34'd0;                   // clear product accumulator
            count        <= 3'd0;                    // reset count
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (!rdy) begin
            // Decode booth_bits
            // multiplier[2:0] contains bits [2], [1], and [0] where [0] is LSB zero appended
            case (multiplier[2:0])
                3'b000,
                3'b111: factor <=  3'sd0;
                3'b001,
                3'b010: factor <=  3'sd1;
                3'b011: factor <=  3'sd2;
                3'b100: factor <= -3'sd2;
                3'b101,
                3'b110: factor <= -3'sd1;
                default: factor <= 3'sd0;
            endcase

            // Compute partial product
            partial = factor * (multiplicand <<< (count * 2));

            // Accumulate partial product
            product <= product + partial;

            // Shift multiplier right by 2 bits for next cycle
            multiplier <= multiplier >> 2;

            // Increment count
            count <= count + 1'b1;

            // Check if done after 4 cycles
            if (count == 3'd3) begin
                p <= product[15:0];  // Output lower 16 bits as product
                rdy <= 1'b1;
            end
        end else begin
            // Hold ready high until reset
            rdy <= 1'b1;
        end
    end

endmodule