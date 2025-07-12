module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplicand
    input      [7:0]  b,       // multiplier
    output reg [15:0] p,       // product output
    output reg        rdy       // ready signal
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE    = 2'd0,
        RUNNING = 2'd1,
        DONE    = 2'd2
    } state_t;
    state_t state, next_state;

    // Extended multiplier with appended zero for radix-4 encoding (17 bits)
    reg [16:0] multiplier_ext;

    // Signed 16-bit multiplicand sign-extended
    reg signed [15:0] multiplicand;

    // 32-bit signed accumulator for partial product (to avoid overflow)
    reg signed [31:0] product_acc;

    // Iteration counter: 0 to 3 (4 iterations for 8 bits / 2 bits per iteration)
    reg [2:0] iter_cnt;

    // Next cycle signals
    reg signed [31:0] product_acc_next;
    reg [16:0] multiplier_ext_next;
    reg [2:0] iter_cnt_next;
    state_t next_state_sync;

    // Helper function: Booth recoding for radix-4
    // input: 3 bits of multiplier (m2 m1 m0)
    // output: signed integer multiplier factor: -2,-1,0,1,2
    function automatic signed [1:0] booth_decode(input [2:0] bits);
        begin
            case(bits)
                3'b000,
                3'b111: booth_decode = 2'sd0; // 0
                3'b001,
                3'b010: booth_decode = 2'sd1; // +1
                3'b011: booth_decode = 2'sd2; // +2
                3'b100: booth_decode = -2;    // -2
                3'b101,
                3'b110: booth_decode = -1;    // -1
                default: booth_decode = 2'sd0;
            endcase
        end
    endfunction

    // Extract current 3 bits for radix-4 encoding (bits at pos = 2*iter_cnt + 1 downto 2*iter_cnt -1)
    wire [2:0] booth_bits = multiplier_ext[(2*iter_cnt)+1 -: 3];

    // Multiplier factor from booth decoding (range -2..2)
    wire signed [1:0] mult_factor = booth_decode(booth_bits);

    // Compute partial add/subtract = multiplicand * mult_factor
    wire signed [31:0] partial_prod = (mult_factor == 2'sd0) ? 32'sd0 :
                                      (mult_factor == 2'sd1) ? { {16{multiplicand[15]}}, multiplicand } :
                                      (mult_factor == 2'sd2) ? { {15{multiplicand[15]}}, multiplicand, 1'b0 } : // multiplicand << 1 (times 2)
                                      (mult_factor == -2) ? -({ {15{multiplicand[15]}}, multiplicand, 1'b0 }) :
                                      (mult_factor == -1) ? -({ {16{multiplicand[15]}}, multiplicand }) :
                                      32'sd0;

    // Next product_acc after adding partial product shifted by 2*iter_cnt bits
    wire signed [31:0] shifted_partial = partial_prod <<< (2*iter_cnt);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'd0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier_ext <= {b, 1'b0}; // 8 bits of b plus appended zero LSB
            product_acc <= 32'sd0;
            iter_cnt <= 3'd0;
        end else begin
            state <= next_state_sync;
            if (state == IDLE) begin
                // Load inputs on reset release / start multiplication
                multiplicand <= {{8{a[7]}}, a};
                multiplier_ext <= {b, 1'b0}; // multiplier extended with zero LSB for Booth
                product_acc <= 32'sd0;
                iter_cnt <= 3'd0;
                rdy <= 1'b0;
            end else if (state == RUNNING) begin
                product_acc <= product_acc + shifted_partial;
                iter_cnt <= iter_cnt + 1;
            end else if (state == DONE) begin
                rdy <= 1'b1;
                p <= product_acc[15:0]; // lower 16 bits are product output
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state_sync = state;
        case (state)
            IDLE: begin
                next_state_sync = RUNNING;
            end
            RUNNING: begin
                if (iter_cnt == 3'd3)
                    next_state_sync = DONE;
                else
                    next_state_sync = RUNNING;
            end
            DONE: begin
                // stay in DONE until reset
                next_state_sync = DONE;
            end
            default: next_state_sync = IDLE;
        endcase
    end

endmodule