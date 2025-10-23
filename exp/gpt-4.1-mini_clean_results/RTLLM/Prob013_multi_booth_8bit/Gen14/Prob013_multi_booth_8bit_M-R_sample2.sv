module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,       // multiplicand
    input   [7:0]   b,       // multiplier
    output reg [15:0] p,     // product output
    output reg      rdy       // ready flag
);

    // FSM states
    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;

    // Sign-extended multiplicand and multiplier
    reg signed [16:0] multiplicand;  // 16 bits + 1 sign bit for safe shifts
    reg        [16:0] multiplier;    // 16 bits multiplier + 1 appended zero bit for Booth recoding

    reg signed [31:0] product;       // accumulator, wider than output to avoid overflow

    reg [3:0] cycle_count;           // counts 0 to 7 (8 cycles for 8 groups of 2 bits)

    // Booth recode function
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 3'sd0;    // 0
                3'b001, 3'b010: booth_decode = 3'sd1;    // +1
                3'b011:          booth_decode = 3'sd2;    // +2
                3'b100:          booth_decode = -3'sd2;   // -2
                3'b101, 3'b110: booth_decode = -3'sd1;   // -1
                default:         booth_decode = 3'sd0;
            endcase
        end
    endfunction

    // Extract 3 bits for Booth recode each cycle
    wire [2:0] booth_bits;
    wire signed [2:0] factor;
    integer bit_idx_high, bit_idx_mid, bit_idx_low;

    // Calculate indices for current group (2 bits per cycle)
    // multiplier is 17 bits wide: bits [16:0]
    // For cycle_count = i (0..7):
    // booth_bits = {multiplier[2*i+1], multiplier[2*i], multiplier[2*i -1 (or 0 if <0)]}
    // Clip indices within [0..16]; if out of range, use 0

    // Helper function to safely get multiplier bit or 0 if out of range
    function bit safe_bit;
        input integer idx;
        begin
            if (idx < 0 || idx > 16)
                safe_bit = 1'b0;
            else
                safe_bit = multiplier[idx];
        end
    endfunction

    // Compute bits indices for the current cycle combinationally
    always @(*) begin
        bit_idx_high = 2*cycle_count + 1;
        bit_idx_mid  = 2*cycle_count;
        bit_idx_low  = 2*cycle_count - 1;
    end

    assign booth_bits = {safe_bit(bit_idx_high), safe_bit(bit_idx_mid), safe_bit(bit_idx_low)};
    assign factor = booth_decode(booth_bits);

    // Partial product combinational
    wire signed [31:0] partial_product;
    assign partial_product = (factor == 3'sd0) ? 32'sd0 :
                             (factor == 3'sd1) ? (multiplicand <<< (2*cycle_count)) :
                             (factor == 3'sd2) ? (multiplicand <<< (2*cycle_count + 1)) :
                             (factor == -3'sd1)? -(multiplicand <<< (2*cycle_count)) :
                             (factor == -3'sd2)? -(multiplicand <<< (2*cycle_count + 1)) :
                             32'sd0;

    // Sequential logic for FSM and registers
    always @(posedge clk) begin
        if (reset) begin
            // Initialize and start multiplication immediately on reset
            state       <= RUN;
            rdy         <= 1'b0;
            cycle_count <= 4'd0;
            product     <= 32'sd0;
            multiplicand<= {{9{a[7]}}, a};  // sign-extend 8 to 17 bits
            multiplier  <= {b, 1'b0, 8'b0}; // Prepare 17-bit multiplier: b[7:0], 1'b0 appended LSB, remaining zero (total 17 bits)
                                             // Actually, to match indexing, place b at bits [8:1], 0 at bit 0, and zeros at bits 9 to 16
            // But the problem requires multiplier is sign-extended; let's sign extend b[7:0] to 16 bits and append 0 LSB:
            multiplier <= {{9{b[7]}}, b, 1'b0};
            p           <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    product <= 32'sd0;
                    cycle_count <= 4'd0;
                    // Wait for start (not needed since start immediately after reset)
                end

                RUN: begin
                    // Accumulate partial product each cycle
                    product <= product + partial_product;

                    if (cycle_count == 4'd7) begin
                        p <= product[15:0];   // output lower 16 bits
                        rdy <= 1'b1;
                    end

                    cycle_count <= cycle_count + 1;
                end

                DONE: begin
                    // Hold output and ready until reset
                    rdy <= 1'b1;
                end

                default: begin
                    // Safety fallback
                    state <= IDLE;
                    rdy <= 1'b0;
                    product <= 32'sd0;
                    cycle_count <= 4'd0;
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = RUN;
            RUN:  next_state = (cycle_count == 4'd7) ? DONE : RUN;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule