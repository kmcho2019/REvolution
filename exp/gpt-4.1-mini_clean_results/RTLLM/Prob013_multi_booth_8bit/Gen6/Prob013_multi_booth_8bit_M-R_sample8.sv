module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,      // multiplicand
    input  wire [7:0]  b,      // multiplier
    output reg  [15:0] p,      // product output
    output reg         rdy      // ready signal
);

    // State encoding
    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;

    reg state, next_state;

    // Sign-extended multiplicand and multiplier registers
    reg signed [15:0] multiplicand;
    reg signed [16:0] multiplier_reg; // 8 bits + sign extension + appended zero bit

    // Accumulator for partial sums, 32 bits signed
    reg signed [31:0] accumulator;

    // Cycle counter: 0 to 3 (4 cycles)
    reg [2:0] cycle_cnt;

    // Extract current Booth bits for Radix-4 (3 bits)
    wire [2:0] booth_bits = multiplier_reg[1:0] | {multiplier_reg[1], multiplier_reg[0], 1'b0}; 
    // Actually, per standard Radix-4 Booth, booth_bits = {multiplier_reg[1], multiplier_reg[0], multiplier_reg[-1]}
    // multiplier_reg[-1] does not exist, so append 0 at LSB; corrected below:

    // Correct booth bits extraction: bits at positions (1,0,-1) => multiplier_reg[1], multiplier_reg[0], appended zero bit (0)
    wire [2:0] booth_code = {multiplier_reg[1], multiplier_reg[0], 1'b0};

    // Booth decoding function: maps 3-bit code to signed multiplier -2 to 2
    function signed [2:0] booth_decode;
        input [2:0] code;
        begin
            case (code)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2;
                3'b101, 3'b110: booth_decode = -3'sd1;
                default:        booth_decode = 3'sd0; // safe default
            endcase
        end
    endfunction

    wire signed [2:0] factor = booth_decode(booth_code);

    // Compute partial product: multiplicand * factor, then shifted by 2*cycle_cnt bits left
    // multiplicand is 16 bits signed; factor is -2..2 signed 3 bits
    // Result is 32 bits signed partial product aligned with accumulator position

    wire signed [31:0] shifted_partial_product;

    // First multiply multiplicand (16 bits) by factor (3 bits signed)
    wire signed [18:0] partial_product_raw = multiplicand * factor; // max bits: 16+3=19 bits signed

    // Shift partial_product_raw left by 2 * cycle_cnt (max shift 6 bits) for proper bit alignment in accumulator
    assign shifted_partial_product = $signed({{13{partial_product_raw[18]}}, partial_product_raw}) << (cycle_cnt * 2);

    // Sequential logic and FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= {{8{a[7]}}, a};             // Sign-extend multiplicand
            multiplier_reg <= {{8{b[7]}}, b, 1'b0};     // Sign-extend multiplier and append zero bit
            accumulator <= 32'sd0;
            cycle_cnt <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    accumulator <= 32'sd0;
                    cycle_cnt <= 3'd0;
                    multiplicand <= {{8{a[7]}}, a};             // Reload on start to support new inputs
                    multiplier_reg <= {{8{b[7]}}, b, 1'b0};     // Reload multiplier + appended zero bit
                end
                RUN: begin
                    accumulator <= accumulator + shifted_partial_product;

                    // Arithmetic right shift multiplier_reg by 2 bits
                    // Maintain sign extension (multiplier_reg is signed 17 bits)
                    multiplier_reg <= multiplier_reg >>> 2;

                    cycle_cnt <= cycle_cnt + 1;
                    if (cycle_cnt == 3'd3) begin
                        p <= accumulator[15:0];
                        rdy <= 1'b1;
                    end
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = RUN;
            RUN:  next_state = (cycle_cnt == 3'd3) ? IDLE : RUN;
            default: next_state = IDLE;
        endcase
    end

endmodule