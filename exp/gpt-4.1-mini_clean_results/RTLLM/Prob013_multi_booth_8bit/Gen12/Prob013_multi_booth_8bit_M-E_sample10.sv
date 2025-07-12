module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplicand input
    input      [7:0]  b,        // multiplier input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // States
    localparam IDLE    = 2'd0;
    localparam RUNNING = 2'd1;
    localparam DONE    = 2'd2;

    reg [1:0] state;

    // Extended multiplicand (17-bit signed) for radix-4 Booth partial product calculations
    reg signed [16:0] multiplicand_ext;

    // Multiplier concatenated with extra bit for Booth encoding (9 bits)
    reg [8:0] multiplier_ext;   // {b, 1'b0} with bit0 the extra zero

    // 34-bit partial product register (signed)
    reg signed [33:0] partial_prod;

    // Iteration counter (0 to 7) because radix-4 processes 2 bits per cycle for 8 bits input
    reg [3:0] cycle_cnt;

    // Booth encoded value in [-2, -1, 0, +1, +2]
    reg signed [2:0] booth_code;

    // Temporary variable for multiplicand multiples (+-0, +-1, +-2)
    reg signed [33:0] mult_term;

    // Decode radix-4 Booth code from 3 bits: multiplier_ext[1: -1] (bits indexed carefully)
    // We'll extract bits: current 2 bits plus previous bit for encoding

    // function to decode Booth bits into multiplier value
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            // bits format: {bit2, bit1, bit0} = [multiplier_ext bit i+1, bit i, bit i-1]
            // Note: bits[2]=upper bit, bits[0]=lower bit (the previous bit)
            case(bits)
                3'b000, 3'b111: booth_decode = 3'd0;
                3'b001, 3'b010: booth_decode = 3'd1;
                3'b011:         booth_decode = 3'd2;
                3'b100:         booth_decode = -3'd2;
                3'b101, 3'b110: booth_decode = -3'd1;
                default:        booth_decode = 3'd0; // safety
            endcase
        end
    endfunction

    integer i;

    always @(posedge clk) begin
        if (reset) begin
            // Initialize on reset
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'd0;
            cycle_cnt <= 4'd0;
            // Sign-extend multiplicand input a to 17-bit (shifted left by 1 for alignment)
            multiplicand_ext <= {a[7], a, 1'b0}; // 8-bit a sign-extended + shifted left 1
            // Prepare multiplier extended (b + 1 zero bit LSB)
            multiplier_ext <= {b, 1'b0};
            // Clear partial product
            partial_prod <= 34'sd0;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    cycle_cnt <= 4'd0;
                    partial_prod <= 34'sd0;
                    multiplicand_ext <= {a[7], a, 1'b0}; // Re-load inputs for new multiplication
                    multiplier_ext <= {b, 1'b0};
                    state <= RUNNING;
                end

                RUNNING: begin
                    // Extract 3 bits for Booth encoding:
                    // For cycle i, bits are multiplier_ext[2*i+1 : 2*i-1]
                    // i from 0..7
                    // Since multiplier_ext is 9 bits (index 8 down to 0), calculate indices carefully:
                    // pos = 2*cycle_cnt
                    // bits: [pos+1 : pos-1], need to handle edges

                    // Calculate index for bits slice
                    // We extend multiplier_ext with zeros for bits < 0
                    reg [2:0] booth_bits;
                    integer pos;
                    pos = 2*cycle_cnt;

                    // Extract bits with boundary checks
                    // bit0 = bit (pos-1), if pos-1 < 0 => 0
                    booth_bits[0] = (pos - 1 >= 0) ? multiplier_ext[pos - 1] : 1'b0;
                    booth_bits[1] = multiplier_ext[pos];
                    booth_bits[2] = (pos + 1 <= 8) ? multiplier_ext[pos + 1] : 1'b0;

                    booth_code <= booth_decode(booth_bits);

                    // Determine multiplicand multiple based on booth_code
                    // Multiply multiplicand_ext by booth_code (-2..2)
                    // multiplicand_ext is signed 17-bit, mult_term is 34-bit signed
                    mult_term = 34'sd0;
                    case (booth_code)
                        3'd0, -3'd0: mult_term = 34'sd0;
                        3'd1:        mult_term = {{17{multiplicand_ext[16]}}, multiplicand_ext};
                        3'd2:        mult_term = {{17{multiplicand_ext[16]}}, multiplicand_ext} <<< 1;
                        -3'd1:       mult_term = - ({{17{multiplicand_ext[16]}}, multiplicand_ext});
                        -3'd2:       mult_term = - ({{17{multiplicand_ext[16]}}, multiplicand_ext} <<< 1);
                        default:     mult_term = 34'sd0;
                    endcase

                    // Accumulate and shift partial product by 2 (arithmetic shift right) after addition
                    partial_prod <= (partial_prod + mult_term) >>> 2;

                    cycle_cnt <= cycle_cnt + 1;

                    if (cycle_cnt == 4'd7) begin
                        // Completed all 8 cycles, multiplication done
                        // Extract 16 LSB bits as product output (the product is correctly aligned)
                        // partial_prod currently shifted right so LSB corresponds to bits [15:0]
                        p <= partial_prod[15:0];
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Hold outputs stable until reset
                    rdy <= 1'b1;
                    // p output stable
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule