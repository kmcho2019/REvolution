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

    // Internal Registers
    reg signed [15:0] multiplicand;  // sign-extended 16-bit multiplicand (8 bits extended)
    reg signed [17:0] multiplier;    // 16 bits multiplier plus one extra LSB bit for Booth recoding (total 18 bits)
    reg signed [31:0] product;       // accumulator for the product (wide enough for partial sums)

    reg [3:0] cycle_count;            // count 0 to 7 for 8 cycles (processing 2 bits per cycle)
    reg [2:0] booth_bits;             // 3 bits for Booth recoding (current 2 bits + prev bit)
    reg signed [2:0] factor;          // factor from Booth recoding: -2,-1,0,1,2
    reg signed [31:0] partial_mul;   // partial multiple for this cycle

    // Booth recode function
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            // Radix-4 Booth recoding table (bits = {y2, y1, y0})
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

    // Compute partial multiple based on factor and multiplicand
    // Shift the multiplicand left by (2 * cycle_count)
    always @(*) begin
        case(factor)
            3'sd0:    partial_mul = 32'sd0;
            3'sd1:    partial_mul = (multiplicand <<< (2 * cycle_count));
            3'sd2:    partial_mul = (multiplicand <<< (2 * cycle_count + 1));  // multiply by 2 means shift by 1 more
           -3'sd1:    partial_mul = -(multiplicand <<< (2 * cycle_count));
           -3'sd2:    partial_mul = -(multiplicand <<< (2 * cycle_count + 1));
            default:  partial_mul = 32'sd0;
        endcase
    end

    // State register and logic
    always @(posedge clk) begin
        if (reset) begin
            state       <= RUN;
            rdy         <= 1'b0;
            cycle_count <= 4'd0;
            product     <= 32'sd0;
            multiplicand<= {{8{a[7]}}, a};       // sign-extend 8-bit to 16-bit
            multiplier  <= {b, 1'b0};             // append zero LSB for Booth recoding
            p           <= 16'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    product <= 32'sd0;
                    cycle_count <= 4'd0;
                    // multiplicand and multiplier remain latched
                    // Wait for start signal or external reset - here we start immediately after reset
                end

                RUN: begin
                    // Compute booth_bits: bits [1:0] + previous bit [0] (multiplier bit below current 2 bits)
                    // Since we process left to right, multiplier is static, we select bits (2*cycle_count +1 : 2*cycle_count -1)
                    // Note: multiplier[0] is appended zero
                    // For 2-bit group i: booth_bits = {multiplier[2*i+1], multiplier[2*i], multiplier[2*i-1]}
                    // For i=0, multiplier[-1] is treated as zero
                    // Implemented carefully with bounds:

                    // Determine booth_bits bits indices:
                    // bit2 = multiplier[2*cycle_count + 1]
                    // bit1 = multiplier[2*cycle_count]
                    // bit0 = multiplier[2*cycle_count - 1] if >= 0 else 0

                    // Clamp indices:
                    integer bit2_idx = 2 * cycle_count + 1;
                    integer bit1_idx = 2 * cycle_count;
                    integer bit0_idx = 2 * cycle_count - 1;

                    reg b2, b1, b0;
                    b2 = (bit2_idx < 18) ? multiplier[bit2_idx] : 1'b0;
                    b1 = (bit1_idx < 18) ? multiplier[bit1_idx] : 1'b0;
                    b0 = (bit0_idx >=0) ? multiplier[bit0_idx] : 1'b0;

                    booth_bits = {b2,b1,b0};
                    factor = booth_decode(booth_bits);

                    product <= product + partial_mul;

                    if (cycle_count == 4'd7) begin
                        p <= product[15:0];
                        rdy <= 1'b1;
                    end

                    cycle_count <= cycle_count + 1;
                end

                DONE: begin
                    // Hold ready signal high until reset
                    rdy <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = RUN;
            RUN:  next_state = (cycle_count == 4'd7) ? DONE : RUN;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule