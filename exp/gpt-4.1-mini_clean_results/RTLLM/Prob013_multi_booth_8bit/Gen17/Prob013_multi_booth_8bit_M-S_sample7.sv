module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready flag
);

    reg signed [15:0] multiplicand;
    reg signed [17:0] product;   // Extra bits to accommodate shifts
    reg [3:0]         count;     // 4 cycles needed (8 bits / 2 bits)
    reg [9:0]         mplier_ext; // multiplier extended with one extra 0 bit at LSB for Booth grouping

    // Decode Booth encoding based on 3 bits
    function signed [2:0] booth_op;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_op = 3'd0;
                3'b001, 3'b010: booth_op = 3'd1;
                3'b011:         booth_op = 3'd2;
                3'b100:         booth_op = -3'd2;
                3'b101, 3'b110: booth_op = -3'd1;
                default:        booth_op = 3'd0;
            endcase
        end
    endfunction

    reg signed [15:0] addend;

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};
            // extend multiplier with an extra 0 bit at LSB for Booth encoding (b[7:0], 0)
            mplier_ext   <= {b, 1'b0};
            product      <= 18'd0;
            count        <= 4'd4;
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (!rdy) begin
            if (count > 0) begin
                // Extract 3 bits: current lowest 2 bits + 1 bit below
                // Bits are mplier_ext[1:0] plus mplier_ext[2]
                // We process LSB first, so use bits: mplier_ext[2:0]
                // At each cycle, shift mplier_ext right by 2 bits
                reg [2:0] booth_bits;
                booth_bits = mplier_ext[2:0];

                // Determine operation
                case (booth_op(booth_bits))
                    3'd0:  addend = 16'sd0;
                    3'd1:  addend = multiplicand;
                    3'd2:  addend = multiplicand <<< 1;
                    -3'd1: addend = -multiplicand;
                    -3'd2: addend = -(multiplicand <<< 1);
                    default: addend = 16'sd0;
                endcase

                // Add the addend shifted by the appropriate amount to product
                product = product + ({{2{addend[15]}}, addend} <<< ( (4 - count)*2 ));

                // Shift multiplier extension right by 2 bits for next cycle
                mplier_ext = mplier_ext >> 2;

                count <= count - 1;
            end else begin
                // Done
                p   <= product[15:0];  // Final product is 16 bits
                rdy <= 1'b1;
            end
        end
    end

endmodule