module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    // FSM states as localparams for compatibility with Verilog 2001
    localparam [1:0]
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2;

    reg [1:0] state, next_state;

    // Sign-extended multiplicand (17 bits: 8 bits + 9 sign bits)
    reg signed [16:0] multiplicand;

    // Multiplier register with appended zero bit LSB for Booth encoding (17 bits)
    reg signed [16:0] multiplier_reg;

    // Accumulator for partial sums (signed 34 bits: enough width for shifted sums)
    reg signed [33:0] accumulator;

    // Cycle counter: 0 to 3 for 4 cycles (8-bit input with radix-4)
    reg [2:0] cycle_cnt;

    // Extract current Booth bits (3 bits) from multiplier_reg for radix-4:
    // bits [1:0] plus bit [-1], which is multiplier_reg[0] LSB from previous cycle,
    // but we appended a zero bit at LSB at start, so the 3 bits for booth code are multiplier_reg[1:0] and multiplier_reg[ -1 ] == multiplier_reg[0]
    wire [2:0] booth_bits;
    assign booth_bits = {multiplier_reg[1], multiplier_reg[0], multiplier_reg[ -1 + 1 ]}; // multiplier_reg[-1] doesn't exist, so use multiplier_reg[0] again

    // To fix negative index problem, we append one zero LSB at multiplier_reg initialization, so the 3 bits are bits [1:0] plus appended zero bit at bit 0
    // So booth_bits = multiplier_reg[1:0] concatenated with multiplier_reg[-1]? Instead, use multiplier_reg[0] as the LSB bit twice is incorrect.
    // The radix-4 Booth recoding takes bits multiplier_reg[1:0] and multiplier_reg[-1] which is the previous LSB bit before bit 0.
    // Since we appended a zero bit at LSB, that bit serves as multiplier_reg[-1].
    // So the bits are multiplier_reg[1:0] plus bit before bit 0 (which is appended zero bit). Therefore, the 3 bits are multiplier_reg[1:0] plus bit 0 shifted in as 0.
    // We can take bits multiplier_reg[1:0] plus multiplier_reg[-1] = 0
    // Thus, booth_bits = {multiplier_reg[1], multiplier_reg[0], 1'b0};
    // Because Verilog does not allow negative indices, we assign as:
    wire [2:0] booth_code;
    assign booth_code = {multiplier_reg[1], multiplier_reg[0], 1'b0};

    // Booth decoding function returns factor (-2..2) according to 3 bits
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 0;
                3'b001, 3'b010: booth_decode = 1;
                3'b011:         booth_decode = 2;
                3'b100:         booth_decode = -2;
                3'b101, 3'b110: booth_decode = -1;
                default:        booth_decode = 0;
            endcase
        end
    endfunction

    // Partial product calculation variable
    reg signed [33:0] partial_product;

    // Compute partial product combinationally based on booth code
    always @(*) begin
        case (booth_decode(booth_code))
            3'sd0: partial_product = 34'sd0;
            3'sd1: partial_product = {{17{multiplicand[16]}}, multiplicand};
            3'sd2: partial_product = {{17{multiplicand[16]}}, multiplicand} <<< 1; // times 2
            -3'sd1: partial_product = -({{17{multiplicand[16]}}, multiplicand});
            -3'sd2: partial_product = -({{17{multiplicand[16]}}, multiplicand} <<< 1);
            default: partial_product = 34'sd0;
        endcase
    end

    // FSM sequential logic and operations
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize registers
            state        <= IDLE;
            rdy          <= 1'b0;
            p            <= 16'd0;
            cycle_cnt    <= 3'd0;
            accumulator  <= 34'sd0;
            multiplicand <= {{9{a[7]}}, a}; // sign-extend 8-bit a to 17 bits
            // sign-extend b to 16 bits, then append zero LSB for Booth
            multiplier_reg <= {{8{b[7]}}, b, 1'b0}; // total 17 bits
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    cycle_cnt <= 3'd0;
                    accumulator <= 34'sd0;
                    multiplicand <= {{9{a[7]}}, a};
                    multiplier_reg <= {{8{b[7]}}, b, 1'b0};
                end

                CALC: begin
                    // Add partial product to accumulator
                    accumulator <= accumulator + partial_product;
                    // Arithmetic right shift multiplier_reg by 2 bits for next Booth bits
                    multiplier_reg <= $signed(multiplier_reg) >>> 2;
                    // Increment cycle count
                    cycle_cnt <= cycle_cnt + 1;
                end

                DONE: begin
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                end

                default: begin
                    // default safe assignments
                    rdy <= 1'b0;
                end
            endcase
        end
    end

    // FSM next state combinational logic
    always @(*) begin
        case (state)
            IDLE:  next_state = CALC;
            CALC:  next_state = (cycle_cnt == 3'd4) ? DONE : CALC;
            DONE:  next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule