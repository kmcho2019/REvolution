module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;
    state_t state, next_state;

    // Registers
    reg signed [8:0] multiplicand;    // sign-extended multiplicand (9 bits)
    reg [8:0] multiplier_ext;          // multiplier extended by 1 bit zero on LSB for Booth recoding (9 bits)
    reg signed [17:0] accumulator;    // 18-bit signed accumulator for partial sums
    reg [2:0] step;                   // step counter 0..4 (5 steps for 8-bit Radix-4)

    // Extract Booth bits: bits [2*step+1 : 2*step-1] from multiplier_ext
    // Because multiplier_ext is 9 bits: bits 8 down to 0 (with 0 LSB)
    wire [2:0] booth_bits;
    assign booth_bits = multiplier_ext[2*step +: 3];

    // Booth operation function returning partial product (18-bit signed)
    function signed [17:0] booth_op;
        input [2:0] bits;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        begin
            case(bits)
                3'b000,
                3'b111: val = 18'sd0;
                3'b001,
                3'b010: val = {{9{mpcand[8]}}, mpcand};             // +1 * multiplicand
                3'b011: val = {{8{mpcand[8]}}, mpcand, 1'b0};       // +2 * multiplicand (shift left 1)
                3'b100: val = -({{8{mpcand[8]}}, mpcand, 1'b0});    // -2 * multiplicand
                3'b101,
                3'b110: val = -({{9{mpcand[8]}}, mpcand});          // -1 * multiplicand
                default: val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (reset == 1'b0) ? CALC : IDLE;   // start calculation after reset deasserted
            CALC:  next_state = (step == 3'd5) ? DONE : CALC;    // done after 5 steps
            DONE:  next_state = (reset == 1'b1) ? IDLE : DONE;   // wait for reset to restart
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= {a[7], a};       // sign-extend multiplicand to 9 bits
            multiplier_ext <= {b, 1'b0};     // extend multiplier by zero bit for Booth recoding
            accumulator <= 18'sd0;
            step <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    // reset internal signals for new calculation
                    accumulator <= 18'sd0;
                    step <= 3'd0;
                    p <= 16'd0;
                    rdy <= 1'b0;
                    // multiplicand and multiplier_ext unchanged during IDLE and CALC
                end
                CALC: begin
                    // accumulate partial product shifted left by 2*step bits (fixed shift)
                    accumulator <= accumulator + (booth_op(booth_bits, multiplicand) << (2*step));
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                end
                DONE: begin
                    p <= accumulator[15:0];  // output lower 16 bits of the accumulator as product
                    rdy <= 1'b1;
                    // hold outputs stable until reset
                end
            endcase
        end
    end

endmodule