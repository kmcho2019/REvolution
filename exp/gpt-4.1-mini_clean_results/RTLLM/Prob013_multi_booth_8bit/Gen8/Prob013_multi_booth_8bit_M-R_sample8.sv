module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand input
    input      [7:0]   b,      // multiplier input
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;
    state_t state;

    // Extended registers
    reg signed [17:0] multiplicand;   // Extended 18-bit multiplicand for shifts and multiplication
    reg [17:0] product;                // Accumulates partial product and multiplier bits with extra LSB bit for Booth recoding
    reg [3:0] ctr;                    // Counts 8 cycles (2 bits per cycle * 8 = 16 bits processed)

    reg signed [17:0] partial_mult;  // Partial multiple added or subtracted each cycle

    // Extract 3 bits for Radix-4 Booth recoding each cycle
    wire [2:0] booth_bits = product[1:0] | (product[2] << 2);

    // Booth encoding function (combinational) for Radix-4: maps booth_bits to partial multiples of multiplicand
    always @(*) begin
        case (product[2:0])
            3'b000, 3'b111: partial_mult = 18'sd0;
            3'b001, 3'b010: partial_mult = multiplicand;
            3'b011:         partial_mult = multiplicand <<< 1; // 2*M
            3'b100:         partial_mult = - (multiplicand <<< 1); // -2*M
            3'b101, 3'b110: partial_mult = - multiplicand;
            default:        partial_mult = 18'sd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Sign-extend inputs to 18 bits
            multiplicand <= { {10{a[7]}}, a };  // multiplicand sign-extended to 18 bits
            // Product initialized with multiplier in lower bits and extra 0 bit at LSB
            product <= {8'd0, b, 1'b0}; // 8 bits multiplier + 1 zero bit + 9 zero bits = total 18 bits
            ctr <= 4'd0;
            rdy <= 1'b0;
            p <= 16'd0;
            state <= CALC;
        end else begin
            case(state)
                IDLE: begin
                    // Wait here (not used in this design as start triggered on reset)
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
                CALC: begin
                    if (ctr < 4'd8) begin
                        // Add partial multiple to upper bits of product (bits 17 down to 2)
                        // product[17:2] += partial_mult
                        product[17:2] <= product[17:2] + partial_mult[17:2];

                        // Arithmetic right shift by 2 bits for next iteration (note: product is signed)
                        product <= $signed(product) >>> 2;

                        ctr <= ctr + 1;
                    end else begin
                        // Multiplication done
                        p <= product[17:2];  // Product is in upper bits after shifts (16-bit result)
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Hold product and ready until reset
                    rdy <= 1'b1;
                    p <= p;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule