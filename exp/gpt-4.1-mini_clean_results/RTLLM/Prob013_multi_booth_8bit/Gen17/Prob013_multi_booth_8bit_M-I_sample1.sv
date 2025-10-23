module multi_booth_8bit (
    input          clk,
    input          reset,
    input  [7:0]   a,    // multiplicand (signed)
    input  [7:0]   b,    // multiplier (signed)
    output reg [15:0] p, // product output
    output reg      rdy   // ready signal
);

    // FSM states
    localparam IDLE = 2'd0;
    localparam RUN  = 2'd1;
    localparam DONE = 2'd2;

    reg [1:0] state, next_state;

    // Internal registers
    reg signed [8:0] multiplicand;   // 9-bit sign-extended multiplicand (a)
    reg signed [8:0] multiplier;     // 9-bit multiplier extended with LSB 0 for Booth
    reg signed [16:0] accumulator;   // 17-bit accumulator for partial sums and shifts
    reg [2:0] step;                  // 0 to 4 (5 steps for 8-bit radix-4 Booth)

    wire [2:0] booth_bits;

    // Extract the current 3 bits for Booth encoding from multiplier (lowest 3 bits)
    assign booth_bits = multiplier[2:0];

    // Partial product combinational logic:
    // Use the pre-sign-extended multiplicand directly to avoid repeated sign extension
    reg signed [16:0] partial_product;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 17'sd0;
            3'b001, 3'b010: partial_product = {{8{multiplicand[8]}}, multiplicand};       // +1 * multiplicand
            3'b011:         partial_product = {{7{multiplicand[8]}}, multiplicand, 1'b0};  // +2 * multiplicand (shift left 1)
            3'b100:         partial_product = -({{7{multiplicand[8]}}, multiplicand, 1'b0}); // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{8{multiplicand[8]}}, multiplicand});     // -1 * multiplicand
            default:        partial_product = 17'sd0;
        endcase
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = reset ? RUN : IDLE;
            RUN:  next_state = (step == 3'd4) ? DONE : RUN;
            DONE: next_state = reset ? RUN : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: FSM, accumulator, multiplier shift, step counter, outputs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset/start
            multiplicand <= {a[7], a};       // sign-extend a to 9 bits
            multiplier <= {b, 1'b0};         // multiplier with appended zero for Booth bits
            accumulator <= 17'sd0;
            step <= 3'd0;
            p <= 16'd0;
            rdy <= 1'b0;
            state <= RUN;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end

                RUN: begin
                    // Accumulate shifted partial product
                    accumulator <= accumulator + (partial_product <<< (2 * step));
                    // Arithmetic right shift multiplier by 2 bits with sign extension
                    multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };
                    step <= step + 1'b1;
                    rdy <= 1'b0;
                end

                DONE: begin
                    // Output the lower 16 bits of accumulator as product
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold all states until next reset
                end

                default: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
            endcase
        end
    end

endmodule