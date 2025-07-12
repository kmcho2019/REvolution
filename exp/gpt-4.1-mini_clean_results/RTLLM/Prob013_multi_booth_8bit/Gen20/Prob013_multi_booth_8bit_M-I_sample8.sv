module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplier
    input      [7:0]  b,       // multiplicand
    output reg [15:0] p,       // product
    output reg        rdy       // ready
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Registers
    reg signed [15:0] multiplicand;         // sign-extended multiplicand
    reg signed [31:0] product_accum;        // accumulation register (32 bits to avoid overflow)
    reg [16:0] multiplier_ext;              // multiplier extended with appended zero bit at LSB for Booth recoding
    reg [3:0] cycle_cnt;                    // counts 0 to 7 (8 cycles)

    // Booth recode signals
    wire [2:0] booth_bits;
    reg signed [2:0] booth_sel;
    reg signed [17:0] pp; // Partial product (up to ±2 * multiplicand), wider for safe addition

    // Assign booth bits: bits [2:0] = multiplier_ext[2+2*cycle_cnt : 0+2*cycle_cnt]
    assign booth_bits = multiplier_ext[cycle_cnt*2 +: 3];

    // Combinational logic to determine partial product based on Booth encoding
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: pp = 18'sd0;                    // 0 * multiplicand
            3'b001, 3'b010: pp = {multiplicand, 1'b0} >>> 1;  // +1 * multiplicand = multiplicand * 1 (since multiplicand is 16 bits, shift left 0)
            3'b011:         pp = multiplicand <<< 1;       // +2 * multiplicand
            3'b100:         pp = -(multiplicand <<< 1);    // -2 * multiplicand
            3'b101, 3'b110: pp = -({multiplicand, 1'b0} >>> 1); // -1 * multiplicand
            default:        pp = 18'sd0;
        endcase
    end

    // State transitions
    always @(*) begin
        case(state)
            IDLE: next_state = (reset == 1'b0) ? CALC : IDLE;
            CALC: next_state = (cycle_cnt == 4'd8) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= 16'sd0;
            multiplier_ext <= 17'd0;
            product_accum <= 32'sd0;
            cycle_cnt <= 4'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    cycle_cnt <= 4'd0;
                    rdy <= 1'b0;
                    // Sign-extend inputs
                    multiplicand <= {{8{b[7]}}, b};
                    multiplier_ext <= {a, 1'b0}; // Append zero LSB for Booth recoding
                    product_accum <= 32'sd0;
                end
                CALC: begin
                    // Add partial product shifted by 2*cycle_cnt bits
                    // pp is 18 bits, shift left by 2*cycle_cnt bits before adding
                    product_accum <= product_accum + ({{14{pp[17]}}, pp} <<< (cycle_cnt*2));
                    cycle_cnt <= cycle_cnt + 1'b1;
                end
                DONE: begin
                    p <= product_accum[15:0];
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule