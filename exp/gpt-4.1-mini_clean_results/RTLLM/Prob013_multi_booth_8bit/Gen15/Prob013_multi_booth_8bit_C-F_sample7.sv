module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    // Internal signed registers
    reg signed [8:0] multiplicand;      // multiplicand sign-extended to 9 bits
    reg [8:0] multiplier;                // multiplier extended by 1 LSB zero bit (for Booth recoding)
    reg signed [17:0] accumulator;      // 18-bit signed accumulator for partial sums
    reg [2:0] step;                     // 3-bit step counter (0 to 4 for 5 steps)

    wire [2:0] booth_bits;

    // Assign booth_bits: 3 LSBs of multiplier for current step's Booth encoding
    assign booth_bits = multiplier[2:0];

    // Booth operation function returns 18-bit signed partial product based on 3-bit Booth code and multiplicand
    function signed [17:0] booth_op;
        input [2:0] bits;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        begin
            case(bits)
                3'b000,
                3'b111: val = 18'sd0;
                3'b001,
                3'b010: val = {{9{mpcand[8]}}, mpcand};            // +1 * multiplicand
                3'b011: val = {{8{mpcand[8]}}, mpcand, 1'b0};      // +2 * multiplicand (shift left 1)
                3'b100: val = -({{8{mpcand[8]}}, mpcand, 1'b0});   // -2 * multiplicand
                3'b101,
                3'b110: val = -({{9{mpcand[8]}}, mpcand});         // -1 * multiplicand
                default: val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // FSM combinational next state logic
    always @(*) begin
        case(state)
            IDLE:    next_state = (reset == 1'b0) ? RUN : IDLE; // Start RUN after reset is released
            RUN:     next_state = (step == 3'd5) ? DONE : RUN;   // After 5 steps, go DONE
            DONE:    next_state = (reset == 1'b1) ? IDLE : DONE; // Wait for reset to start over
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and datapath updates
    always @(posedge clk) begin
        if (reset) begin
            // Initialize all registers synchronously on reset assertion (active high)
            state       <= IDLE;
            multiplicand <= {a[7], a};           // sign-extend multiplicand to 9 bits
            multiplier   <= {b, 1'b0};           // extend multiplier with 1 LSB zero for Booth recoding
            accumulator  <= 18'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Prepare for multiplication run
                    rdy <= 1'b0;
                    p   <= 16'd0;
                    step <= 3'd0;
                    accumulator <= 18'sd0;
                    // multiplicand and multiplier remain stable until reset
                end

                RUN: begin
                    // Accumulate partial product shifted by 2*step bits
                    accumulator <= accumulator + (booth_op(booth_bits, multiplicand) <<< (2*step));

                    // Arithmetic shift right multiplier by 2 bits (with sign extension)
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                    step <= step + 1'b1;

                    rdy <= 1'b0;
                end

                DONE: begin
                    p <= accumulator[15:0];  // Output lower 16 bits of product
                    rdy <= 1'b1;             // Signal ready
                    // Hold registers stable until reset asserted
                end

                default: begin
                    // Safe defaults
                    rdy <= 1'b0;
                    p   <= 16'd0;
                end
            endcase
        end
    end

endmodule