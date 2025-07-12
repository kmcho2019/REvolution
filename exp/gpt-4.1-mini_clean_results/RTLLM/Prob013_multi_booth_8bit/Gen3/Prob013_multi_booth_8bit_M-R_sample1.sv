module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,
    input   [7:0]   b,
    output reg [15:0] p,
    output reg      rdy
);

    // Internal registers
    reg signed [17:0] product;         // Partial product (18 bits for sign extension)
    reg signed [15:0] multiplicand;    // Sign-extended multiplicand (16 bits)
    reg [8:0]         multiplier_ext;  // Multiplier extended by 1 LSB zero for Booth (9 bits)
    reg [2:0]         cycle;           // Cycle counter (0..4)

    // Combinational function for Booth radix-4 encoding of 3 bits
    function signed [17:0] booth_calc;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_calc = 18'sd0;
                3'b001, 3'b010: booth_calc = { {2{multiplicand[15]}}, multiplicand };        // +1 * multiplicand
                3'b011:         booth_calc = { {2{multiplicand[15]}}, multiplicand } << 1; // +2 * multiplicand
                3'b100:         booth_calc = -({ {2{multiplicand[15]}}, multiplicand } << 1);// -2 * multiplicand
                3'b101, 3'b110: booth_calc = -({ {2{multiplicand[15]}}, multiplicand });    // -1 * multiplicand
                default:        booth_calc = 18'sd0;
            endcase
        end
    endfunction

    // Sequential process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand   <= { {8{a[7]}}, a };   // Sign-extend multiplicand to 16 bits
            multiplier_ext <= {b, 1'b0};          // Extend multiplier by 1 bit at LSB for Booth encoding
            product        <= 18'sd0;             // Clear partial product
            cycle          <= 3'd0;               

            p              <= 16'd0;
            rdy            <= 1'b0;
        end else if (!rdy) begin
            if (cycle < 4) begin
                // Extract 3 bits for Booth encoding from multiplier_ext shifted by 2*cycle bits
                // No reg declaration inside always block, define wire outside
                // We create a localwire by slicing multiplier_ext combinationally
                // Since this is inside always, we use a local variable instead
                // We cannot declare reg inside always, so use a temporary variable before always
                // Instead, move the booth bits extraction outside always with a wire and pass cycle as register, but cycle is register
                // So do this: calculate in a separate combinational block or assign at top.

                // So here, we create a wire to hold booth_bits outside and use it here:

                // But in Verilog we cannot read registers in always block combinationally for indexing with variable index.
                // Solution: create a combinational function to extract booth bits.

                // Let's define a function to extract 3 bits of multiplier_ext at index 2*cycle.

                reg [2:0] booth_bits;

                // Extract bits [2*cycle +1 : 2*cycle -1], but with the extension for negative index handled by zero padding

                // For cycle 0: bits [1 : -1] => bits [1:0] with zero padding for bit -1

                // Define the function get_booth_bits:

                // Since we cannot define function inside always, we define outside.

                // For clarity, declare booth_bits with case statement based on cycle.

                case(cycle)
                    3'd0: booth_bits = multiplier_ext[1:0] | {1'b0};          // bits [1:0] + bit -1 = 0
                    3'd1: booth_bits = multiplier_ext[3:1];
                    3'd2: booth_bits = multiplier_ext[5:3];
                    3'd3: booth_bits = multiplier_ext[7:5];
                    default: booth_bits = 3'b000;
                endcase

                // However this can be done more elegantly by shifting multiplier_ext by 2*cycle and taking bits [2:0].

                // Let's declare a wire outside to compute booth_bits.

                // For now, inside always block, safe to do:

                // Assign booth_bits = (multiplier_ext >> (2*cycle)) & 3'b111;

                booth_bits = (multiplier_ext >> (2*cycle)) & 3'b111;

                // Update product
                product <= (product + booth_calc(booth_bits)) >>> 2; // Arithmetic right shift by 2

                cycle <= cycle + 1'b1;
            end else begin
                // Multiplication complete
                p   <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule