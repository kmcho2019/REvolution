module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,       // multiplicand (signed)
    input  [7:0]    b,       // multiplier   (signed)
    output reg [15:0] p,     // product output
    output reg       rdy      // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        LOAD = 2'd1,
        RUN  = 2'd2,
        DONE = 2'd3
    } state_t;
    
    state_t state, next_state;

    // Internal registers
    reg signed [8:0] multiplicand;     // sign extended multiplicand (9 bits)
    reg [8:0] multiplier;               // multiplier extended with zero LSB for Booth recode (9 bits)
    reg signed [17:0] accumulator;     // 18-bit signed accumulator

    reg [2:0] iteration;                // counts 0..4 (5 iterations)

    wire [2:0] booth_bits;

    assign booth_bits = multiplier[2:0]; // 3 bits for Booth recoding

    // Booth operation function: returns 18-bit signed partial product
    function signed [17:0] booth_op(
        input [2:0] bits,
        input signed [8:0] mpcand
    );
        begin
            case(bits)
                3'b000, 3'b111: booth_op = 18'sd0;
                3'b001, 3'b010: booth_op = {{9{mpcand[8]}}, mpcand};             // +1 * multiplicand
                3'b011:         booth_op = {{8{mpcand[8]}}, mpcand, 1'b0};       // +2 * multiplicand (shift left 1)
                3'b100:         booth_op = -({{8{mpcand[8]}}, mpcand, 1'b0});    // -2 * multiplicand
                3'b101, 3'b110: booth_op = -({{9{mpcand[8]}}, mpcand});          // -1 * multiplicand
                default:        booth_op = 18'sd0;
            endcase
        end
    endfunction

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:  next_state = (reset) ? IDLE : LOAD;
            LOAD:  next_state = RUN;
            RUN:   next_state = (iteration == 3'd5) ? DONE : RUN;
            DONE:  next_state = (reset) ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential block: FSM and datapath
    always @(posedge clk) begin
        if (reset) begin
            // synchronous reset: clear registers
            state       <= IDLE;
            multiplicand <= 9'sd0;
            multiplier   <= 9'd0;
            accumulator  <= 18'sd0;
            iteration    <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Clear output signals
                    p   <= 16'd0;
                    rdy <= 1'b0;
                end

                LOAD: begin
                    // sign-extend multiplicand and multiplier, prepare multiplier with appended zero
                    multiplicand <= {a[7], a};   // 9-bit sign extended
                    multiplier   <= {b, 1'b0};   // 9-bit multiplier with appended zero LSB
                    accumulator  <= 18'sd0;
                    iteration    <= 3'd0;
                    rdy          <= 1'b0;
                    p            <= 16'd0;
                end

                RUN: begin
                    // Accumulate shifted partial product
                    accumulator <= accumulator + (booth_op(booth_bits, multiplicand) <<< (iteration * 2));

                    // Arithmetic right shift multiplier by 2 bits (sign extend)
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                    iteration <= iteration + 1'b1;
                end

                DONE: begin
                    p   <= accumulator[15:0];
                    rdy <= 1'b1;
                end

                default: begin
                    // Safe defaults (should not happen)
                    p   <= 16'd0;
                    rdy <= 1'b0;
                end
            endcase
        end
    end

endmodule