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

    // Extended registers
    reg signed [15:0] multiplicand;      // sign-extended multiplicand (16-bit)
    reg signed [15:0] accumulator;       // 16-bit signed accumulator for partial sums
    reg [9:0] multiplier;                // multiplier extended with extra 2 bits for Booth recoding

    reg [2:0] step;                     // 3-bit step counter (0 to 4 for 5 steps)

    // Extract 3 LSB bits of multiplier for Booth encoding
    wire [2:0] booth_bits = multiplier[2:0];

    // Booth recoding function - returns signed 16-bit partial product
    function signed [15:0] booth_op;
        input [2:0] bits;
        input signed [15:0] mpcand;
        reg signed [15:0] val;
        begin
            case(bits)
                3'b000,
                3'b111: val = 16'sd0;
                3'b001,
                3'b010: val = mpcand;             // +1 * multiplicand
                3'b011: val = mpcand <<< 1;       // +2 * multiplicand
                3'b100: val = -(mpcand <<< 1);    // -2 * multiplicand
                3'b101,
                3'b110: val = -mpcand;            // -1 * multiplicand
                default: val = 16'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = (reset == 1'b0) ? RUN : IDLE;   // Start RUN when reset deasserted
            RUN:  next_state = (step == 3'd5) ? DONE : RUN;    // After 5 steps, go DONE
            DONE: next_state = (reset == 1'b1) ? IDLE : DONE; // Wait for reset to restart
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic and datapath
    always @(posedge clk) begin
        if (reset) begin
            // Initialize on synchronous reset (active high)
            state       <= IDLE;
            multiplicand <= {{8{a[7]}}, a};         // sign-extend 8-bit to 16-bit
            multiplier   <= {b, 2'b00};              // extend multiplier by 2 bits LSB zero for Booth encoding
            accumulator  <= 16'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    // Prepare registers for multiplication
                    rdy <= 1'b0;
                    p   <= 16'd0;
                    step <= 3'd0;
                    accumulator <= 16'sd0;
                    multiplicand <= {{8{a[7]}}, a};
                    multiplier <= {b, 2'b00};
                end

                RUN: begin
                    // Add partial product shifted by (2 * step)
                    accumulator <= accumulator + (booth_op(booth_bits, multiplicand) <<< (2*step));
                    // Arithmetic shift right multiplier by 2 bits with sign extension
                    // Multiplier is 10 bits, so extend sign bit at MSB
                    multiplier <= { {2{multiplier[9]}}, multiplier[9:2] };
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                end

                DONE: begin
                    p <= accumulator;  // output final product
                    rdy <= 1'b1;       // signal ready
                    // Hold values stable until reset
                end

                default: begin
                    rdy <= 1'b0;
                    p   <= 16'd0;
                end
            endcase
        end
    end

endmodule