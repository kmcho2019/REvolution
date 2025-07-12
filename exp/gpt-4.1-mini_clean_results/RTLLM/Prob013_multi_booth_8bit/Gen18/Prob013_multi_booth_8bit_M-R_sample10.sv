module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand
    input      [7:0]  b,      // multiplier
    output reg [15:0] p,      // product
    output reg        rdy      // ready flag
);

    // State encoding for FSM
    typedef enum logic [0:0] {
        IDLE = 1'b0,
        BUSY = 1'b1
    } state_t;

    state_t state, next_state;

    // Sign-extended multiplicand (16 bits)
    reg signed [15:0] multiplicand;

    // Multiplier extension with appended zero bit (9 bits)
    reg [8:0] mplier_ext;

    // Accumulator for product - use wider bits to handle shifts safely
    reg signed [31:0] product_accum;

    // Cycle counter (0 to 3 for 4 cycles)
    reg [1:0] cycle_cnt;

    // Booth decoding function: returns multiplier factor [-2..2]
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'd0;
                3'b001, 3'b010: booth_decode = 3'd1;
                3'b011:         booth_decode = 3'd2;
                3'b100:         booth_decode = -3'd2;
                3'b101, 3'b110: booth_decode = -3'd1;
                default:        booth_decode = 3'd0;
            endcase
        end
    endfunction

    // Partial product to add this cycle
    reg signed [31:0] partial_product;

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = reset ? IDLE : BUSY;
            BUSY: next_state = (cycle_cnt == 2'd3) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            mplier_ext   <= {b, 1'b0};     // Append zero bit at LSB
            product_accum <= 32'sd0;
            cycle_cnt    <= 2'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
            state        <= IDLE;
            partial_product <= 32'sd0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    product_accum <= 32'sd0;
                    cycle_cnt <= 2'd0;
                    if (next_state == BUSY) begin
                        // Reload multiplicand and multiplier extension on start
                        multiplicand <= {{8{a[7]}}, a};
                        mplier_ext   <= {b, 1'b0};
                    end
                end
                BUSY: begin
                    // Extract 3 LSB bits of multiplier extension
                    // bits: mplier_ext[2:0]
                    reg [2:0] bits_to_decode;
                    signed [2:0] mult_factor;
                    bits_to_decode = mplier_ext[2:0];
                    mult_factor = booth_decode(bits_to_decode);

                    // Compute partial product: multiplicand * mult_factor shifted by 2*cycle_cnt
                    partial_product = (multiplicand * mult_factor) <<< (cycle_cnt * 2);

                    // Accumulate partial product
                    product_accum <= product_accum + partial_product;

                    // Shift multiplier extension right by 2 bits for next cycle
                    mplier_ext <= mplier_ext >> 2;

                    // Increment cycle count
                    cycle_cnt <= cycle_cnt + 1;

                    // When last cycle done, set output and ready
                    if (cycle_cnt == 2'd3) begin
                        p <= product_accum[15:0];
                        rdy <= 1'b1;
                    end else begin
                        rdy <= 1'b0;
                    end
                end
                default: begin
                    // Should never reach here; reset to IDLE
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule