module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,    // multiplicand
    input      [7:0]  b,    // multiplier
    output reg [15:0] p,    // product output
    output reg        rdy    // ready signal
);

    // Internal signals and registers
    reg signed [15:0] multiplicand;      // sign-extended multiplicand
    reg [8:0]         multiplier_ext;    // multiplier extended with one LSB zero for Booth encoding
    reg signed [17:0] product;            // 18-bit to hold partial sums with possible overflow
    reg [2:0]         booth_bits;        // current 3 bits for Booth encoding
    reg [2:0]         cycle_cnt;         // cycle count (0 to 4)
    reg               busy;

    // Booth encoding function: maps 3 bits to multiplier factor (-2 to +2)
    function signed [2:0] booth_factor;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_factor = 3'd0;
                3'b001, 3'b010: booth_factor = 3'd1;
                3'b011:        booth_factor = 3'd2;
                3'b100:        booth_factor = -3'd2;
                3'b101, 3'b110: booth_factor = -3'd1;
                default:       booth_factor = 3'd0;
            endcase
        end
    endfunction

    // Multiply multiplicand by factor (-2..+2) with sign extension to 18 bits
    function signed [17:0] mult_factor;
        input signed [15:0] mcand;
        input signed [2:0]  factor;
        begin
            case(factor)
                3'd0:   mult_factor = 18'sd0;
                3'd1:   mult_factor = {{2{mcand[15]}}, mcand};           // Sign extend 16 to 18 bits
                3'd2:   mult_factor = ({{2{mcand[15]}}, mcand}) <<< 1;  // x2
                -3'd1:  mult_factor = -({{2{mcand[15]}}, mcand});
                -3'd2:  mult_factor = -(({{2{mcand[15]}}, mcand}) <<< 1);
                default: mult_factor = 18'sd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // On reset: initialize all registers and signals
            multiplicand <= {{8{a[7]}}, a};           // Sign extend multiplicand to 16 bits
            multiplier_ext <= {b, 1'b0};              // Append 0 LSB for Booth
            product <= 18'sd0;
            cycle_cnt <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
            busy <= 1'b1;                             // Start processing on release of reset
        end else if (busy) begin
            if (cycle_cnt < 3'd5) begin
                // Extract lowest 3 bits for Booth encoding
                booth_bits <= multiplier_ext[1: -1 >= 0 ? -1 : 0] | (multiplier_ext[0] << 0) | (multiplier_ext[2] << 2);
                booth_bits <= multiplier_ext[2:0];
                
                // Compute Booth factor for current bits
                // Here we need a temporary variable, but in sequential block use direct function call below

                // Add partial product: product += multiplicand * booth_factor * 4^cycle_cnt
                // But since radix-4 shifts multiplicand by 2 bits per cycle, we accumulate directly
                
                // Get booth factor
                // Use wire inside always seq block is not possible, so we just do logic below:
                // We will assign booth_bits first then do calculation

                // We perform the operation after assigning booth_bits:
                // For clarity, do in two steps below

                // shift multiplier_ext right by 2 bits (arithmetic shift to preserve sign)
                multiplier_ext <= {2'b00, multiplier_ext[8:2]};

                // Calculate booth_factor and partial product
                // Can't declare local variable inside always block, so use function directly inside RHS

                // product update:
                product <= product + (mult_factor(multiplicand, booth_factor(multiplier_ext[2:0])) <<< (2*cycle_cnt));

                cycle_cnt <= cycle_cnt + 1'b1;
                rdy <= 1'b0;
            end else begin
                // Done: output the product and signal ready
                p <= product[15:0]; // truncate to 16 bits; product is signed
                rdy <= 1'b1;
                busy <= 1'b0;
            end
        end else begin
            // Wait for new inputs (in this design we re-trigger only on reset)
            rdy <= 1'b1; // stable ready signal when idle
        end
    end

endmodule