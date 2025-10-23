module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand (signed)
    input      [7:0]  b,      // multiplier (signed)
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10
    } state_t;

    reg [1:0] state, next_state;

    // Extended multiplicand and multiplier (9 bits)
    reg signed [8:0] multiplicand_reg, multiplicand_next;
    reg signed [8:0] multiplier_reg, multiplier_next;

    // Accumulator (partial product sum), wider to avoid overflow
    reg signed [17:0] accumulator_reg, accumulator_next;

    // Step counter (0 to 5)
    reg [2:0] step_reg, step_next;

    // Ready signal next
    reg rdy_next;

    // Product next
    reg [15:0] p_next;

    // Extract 3 bits from multiplier for Booth recoding
    wire [2:0] booth_bits = multiplier_reg[2:0];

    // Booth partial product generator function
    function signed [17:0] booth_op;
        input [2:0] bits;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        reg signed [17:0] mpcand_18;
        reg signed [17:0] mpcand_x2;
        begin
            // Sign extend multiplicand to 18 bits once
            mpcand_18 = {{9{mpcand[8]}}, mpcand};
            mpcand_x2 = mpcand_18 <<< 1; // multiplicand * 2

            case (bits)
                3'b000, 3'b111: val = 18'sd0;
                3'b001, 3'b010: val = mpcand_18;       // +1 * multiplicand
                3'b011:         val = mpcand_x2;       // +2 * multiplicand
                3'b100:         val = -mpcand_x2;      // -2 * multiplicand
                3'b101, 3'b110: val = -mpcand_18;      // -1 * multiplicand
                default:        val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // Next-state combinational logic
    always @(*) begin
        // Defaults: hold current values
        next_state      = state;
        multiplicand_next = multiplicand_reg;
        multiplier_next = multiplier_reg;
        accumulator_next = accumulator_reg;
        step_next       = step_reg;
        rdy_next        = rdy;
        p_next          = p;

        case(state)
            IDLE: begin
                rdy_next = 1'b0;
                p_next = 16'd0;
                if (!reset) begin
                    next_state = LOAD;
                end
            end

            LOAD: begin
                // Load and sign-extend inputs
                multiplicand_next = {a[7], a};
                multiplier_next = {b, 1'b0}; // Append 0 for booth recoding bit b[-1]
                accumulator_next = 18'sd0;
                step_next = 3'd0;
                rdy_next = 1'b0;
                p_next = 16'd0;

                next_state = CALC;
            end

            CALC: begin
                if (step_reg < 3'd5) begin
                    // Calculate partial product and accumulate
                    accumulator_next = accumulator_reg + (booth_op(booth_bits, multiplicand_reg) <<< (2*step_reg));

                    // Arithmetic shift multiplier right by 2 bits, preserve sign
                    multiplier_next = { {2{multiplier_reg[8]}}, multiplier_reg[8:2] };

                    step_next = step_reg + 1;
                    rdy_next = 1'b0;
                end else begin
                    // Finished multiplication
                    p_next = accumulator_reg[15:0];
                    rdy_next = 1'b1;
                    // Hold state until reset
                    multiplicand_next = multiplicand_reg;
                    multiplier_next = multiplier_reg;
                    accumulator_next = accumulator_reg;
                    step_next = step_reg;
                    next_state = CALC;
                end
            end

            default: begin
                next_state = IDLE;
                rdy_next = 1'b0;
                p_next = 16'd0;
                multiplicand_next = 9'sd0;
                multiplier_next = 9'sd0;
                accumulator_next = 18'sd0;
                step_next = 3'd0;
            end
        endcase
    end

    // Sequential logic: update registers on clock edge with synchronous reset
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            multiplicand_reg <= 9'sd0;
            multiplier_reg <= 9'sd0;
            accumulator_reg <= 18'sd0;
            step_reg <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            state <= next_state;
            multiplicand_reg <= multiplicand_next;
            multiplier_reg <= multiplier_next;
            accumulator_reg <= accumulator_next;
            step_reg <= step_next;
            rdy <= rdy_next;
            p <= p_next;
        end
    end

endmodule