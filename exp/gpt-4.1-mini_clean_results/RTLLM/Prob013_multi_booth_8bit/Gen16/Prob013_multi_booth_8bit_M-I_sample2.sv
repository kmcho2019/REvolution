module multi_booth_8bit (
    input          clk,
    input          reset,
    input  [7:0]   a,    // multiplicand (signed)
    input  [7:0]   b,    // multiplier (signed)
    output reg [15:0] p, // product output
    output reg      rdy   // ready signal
);

    // States encoding
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state;

    // Sign-extended inputs
    // multiplicand: 9 bits signed (a[7] sign extended)
    // multiplier: 10 bits signed (b[7] sign extended, plus 1 LSB zero for booth recode)
    reg signed [8:0] multiplicand;
    reg signed [9:0] multiplier; // one extra MSB sign bit for easy arithmetic shift and one LSB 0

    reg signed [17:0] accumulator;
    reg [2:0] step; // counts 0 to 4 for 5 cycles

    wire [2:0] booth_bits = multiplier[2:0];

    reg signed [17:0] partial_product;

    // Simplify sign-extensions using $signed() for partial product calculation
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;
            3'b001, 3'b010: partial_product = $signed({multiplicand, 9'd0}) >>> 9'd9 /* no shift */; // multiplicand extended left zero, matches width
            3'b011:         partial_product = $signed({multiplicand, 9'd0}) <<< 1;   // 2 * multiplicand
            3'b100:         partial_product = -($signed({multiplicand, 9'd0}) <<< 1);// -2 * multiplicand
            3'b101, 3'b110: partial_product = -$signed({multiplicand, 9'd0});        // -1 * multiplicand
            default:        partial_product = 18'sd0;
        endcase
    end

    // Sequential logic: FSM and datapath
    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= $signed(a);
            multiplier <= {b[7], b, 1'b0};  // 8-bit b + 1 LSB 0 + sign bit b[7]
            accumulator <= 18'sd0;
            step <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
            state <= RUN;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
                RUN: begin
                    // Accumulate partial product only if non-zero to reduce switching
                    if (partial_product != 18'sd0) begin
                        accumulator <= accumulator + (partial_product <<< (2*step));
                    end
                    // Arithmetic right shift multiplier by 2 with sign extension
                    // multiplier is 10 bits: signed shift right 2 bits
                    multiplier <= { {2{multiplier[9]}}, multiplier[9:2] };
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                    if (step == 3'd4) begin
                        state <= DONE;
                    end
                end
                DONE: begin
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold stable outputs
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule