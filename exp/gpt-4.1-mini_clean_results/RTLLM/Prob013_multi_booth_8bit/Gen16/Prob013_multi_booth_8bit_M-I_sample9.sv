module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand (signed)
    input      [7:0]   b,      // multiplier   (signed)
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    // Sign-extended multiplicand (17 bits to match accumulator width)
    reg signed [16:0] multiplicand;

    // Multiplier register with 2 extra LSB zero bits for Booth window extraction (17 bits)
    reg [16:0] multiplier_ext;

    // Accumulator to hold partial sums: signed 17 bits (one extra bit for sign)
    reg signed [16:0] accumulator;

    // Step counter: 0 to 4 (5 steps)
    reg [2:0] step;

    // 3-bit booth window bits extracted from multiplier_ext at 2*step position
    wire [2:0] booth_bits;

    assign booth_bits = multiplier_ext[2*step +: 3]; // 3 bits starting at 2*step

    // Combinational partial product generation based on booth_bits
    // All operands signed 17 bits, partial product signed 17 bits
    reg signed [16:0] partial_product;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 17'sd0;
            3'b001, 3'b010: partial_product = multiplicand;          // +1 * multiplicand
            3'b011:         partial_product = multiplicand <<< 1;    // +2 * multiplicand
            3'b100:         partial_product = -(multiplicand <<< 1); // -2 * multiplicand
            3'b101, 3'b110: partial_product = -multiplicand;         // -1 * multiplicand
            default:        partial_product = 17'sd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Initialize on reset: sign-extend inputs, clear accumulator, step, ready, output
            state        <= IDLE;
            multiplicand <= {{9{a[7]}}, a};   // Sign-extend to 17 bits
            multiplier_ext <= {b, 2'b00};      // Append 2 zero bits at LSB
            accumulator  <= 17'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    // Start multiplication immediately after reset released
                    rdy <= 1'b0;
                    step <= 3'd0;
                    accumulator <= 17'sd0;
                    // Load inputs again to support repeated multiplications if needed
                    multiplicand <= {{9{a[7]}}, a};
                    multiplier_ext <= {b, 2'b00};
                    p <= 16'd0;
                    state <= BUSY;
                end
                BUSY: begin
                    if (step < 3'd5) begin
                        // Accumulate partial product shifted by 2*step bits
                        // Shift left by 2*step bits fits within 17 bits since max shift=8 bits
                        accumulator <= accumulator + (partial_product <<< (2*step));
                        step <= step + 1;
                    end else begin
                        // Multiplication done
                        p <= accumulator[15:0];
                        rdy <= 1'b1;
                        // Hold state until next reset
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule