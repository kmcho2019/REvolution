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
    reg [8:0] multiplier;                // multiplier extended with 1 LSB zero bit (for Booth recoding)
    reg signed [17:0] accumulator;      // 18-bit signed accumulator for partial sums
    reg [1:0] step;                     // 2-bit step counter (0 to 3 for 4 cycles)

    wire [2:0] booth_bits;

    // Assign booth_bits: 3 LSBs of multiplier for current step's Booth encoding
    assign booth_bits = multiplier[2:0];

    // Booth decode function: outputs multiplier factor (-2, -1, 0, 1, 2) based on 3-bit Booth code
    function signed [2:0] booth_factor;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_factor =  3'sd0;
                3'b001, 3'b010: booth_factor =  3'sd1;
                3'b011:         booth_factor =  3'sd2;
                3'b100:         booth_factor = -3'sd2;
                3'b101, 3'b110: booth_factor = -3'sd1;
                default:        booth_factor =  3'sd0;
            endcase
        end
    endfunction

    // Compute partial product from multiplicand and booth factor by shifting and sign extension
    // factor can be -2, -1, 0, 1, 2
    // partial product width: 18 bits to accumulate shifted partial products
    function signed [17:0] partial_product;
        input signed [8:0] mpcand;
        input signed [2:0] factor;
        reg signed [17:0] prod;
        begin
            case(factor)
                3'sd0:  prod = 18'sd0;
                3'sd1:  prod = {{9{mpcand[8]}}, mpcand};           // sign-extend to 18 bits
                3'sd2:  prod = {{8{mpcand[8]}}, mpcand, 1'b0};    // multiply by 2 (shift left 1)
                -3'sd1: prod = -({{9{mpcand[8]}}, mpcand});
                -3'sd2: prod = -({{8{mpcand[8]}}, mpcand, 1'b0});
                default: prod = 18'sd0;
            endcase
            partial_product = prod;
        end
    endfunction

    // FSM combinational next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = (reset == 1'b0) ? RUN : IDLE;      // Start RUN once reset released
            RUN:  next_state = (step == 2'd4) ? DONE : RUN;       // After 4 steps, go to DONE
            DONE: next_state = (reset == 1'b1) ? IDLE : DONE;     // Wait for reset to restart
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and datapath updates
    always @(posedge clk) begin
        if (reset) begin
            // Initialize on synchronous reset (active high)
            state        <= IDLE;
            multiplicand <= {a[7], a};         // sign extend multiplicand to 9 bits
            multiplier   <= {b, 1'b0};         // extend multiplier with 1 zero bit at LSB for Booth recoding
            accumulator  <= 18'sd0;
            step         <= 2'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    p   <= 16'd0;
                    step <= 2'd0;
                    accumulator <= 18'sd0;
                    // multiplicand and multiplier remain until next reset
                end

                RUN: begin
                    // Add partial product shifted by 2*step bits
                    accumulator <= accumulator + (partial_product(multiplicand, booth_factor(booth_bits)) <<< (2*step));

                    // Arithmetic right shift multiplier by 2 bits with sign extension
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                    step <= step + 1'b1;

                    rdy <= 1'b0;
                end

                DONE: begin
                    p <= accumulator[15:0];   // Output final product lower 16 bits
                    rdy <= 1'b1;              // Assert ready
                    // Hold registers stable until reset
                end

                default: begin
                    rdy <= 1'b0;
                    p   <= 16'd0;
                end
            endcase
        end
    end

endmodule