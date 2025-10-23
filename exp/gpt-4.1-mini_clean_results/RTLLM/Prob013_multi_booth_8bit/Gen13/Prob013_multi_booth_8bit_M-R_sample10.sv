module multi_booth_8bit (
    input          clk,
    input          reset,
    input   [7:0]  a,       // multiplicand (signed)
    input   [7:0]  b,       // multiplier   (signed)
    output reg [15:0] p,    // product
    output reg       rdy     // ready signal
);

    // State encoding
    localparam IDLE = 2'd0,
               CALC = 2'd1,
               DONE = 2'd2;

    reg [1:0] state;

    reg signed [8:0] multiplicand;       // sign-extended multiplicand (9 bits)
    reg [8:0] multiplier;                 // multiplier extended with extra bit b[-1]=0 at LSB (9 bits)
    reg signed [17:0] accumulator;       // 18-bit accumulator for partial sums
    reg [2:0] step;                      // counts from 0 to 4 (5 steps for 8-bit radix-4 Booth)

    reg [2:0] booth_bits;                 // 3 bits for Booth recoding
    reg signed [17:0] booth_partial;     // Booth partial product for current step

    // Function to generate Booth partial product based on booth_bits and multiplicand
    function signed [17:0] booth_op;
        input [2:0] bits;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        begin
            case(bits)
                3'b000,
                3'b111: val = 18'sd0;
                3'b001,
                3'b010: val = {{9{mpcand[8]}}, mpcand};       // +1 * multiplicand
                3'b011: val = {{8{mpcand[8]}}, mpcand, 1'b0}; // +2 * multiplicand (shift left by 1)
                3'b100: val = -({{8{mpcand[8]}}, mpcand, 1'b0}); // -2 * multiplicand
                3'b101,
                3'b110: val = -({{9{mpcand[8]}}, mpcand});    // -1 * multiplicand
                default: val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // Combinational booth recode bits extraction
    // bits from multiplier: [2:0] = current two bits + previous bit (LSB)
    always @(*) begin
        booth_bits = multiplier[2:0];
        booth_partial = booth_op(booth_bits, multiplicand);
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize everything and move to IDLE state
            multiplicand <= {a[7], a};    // sign-extend multiplicand to 9 bits
            multiplier   <= {b, 1'b0};    // multiplier extended by one zero LSB (b[-1]=0)
            accumulator  <= 18'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
            state        <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    // Start multiplication immediately at IDLE (or could be triggered by enable)
                    accumulator <= 18'sd0;
                    step <= 3'd0;
                    rdy <= 1'b0;
                    // latch inputs once at start of multiplication to stabilize during calculation
                    multiplicand <= {a[7], a};
                    multiplier <= {b, 1'b0};
                    state <= CALC;
                end

                CALC: begin
                    // Accumulate shifted partial product
                    accumulator <= accumulator + (booth_partial <<< (2*step));
                    // Shift multiplier right logically by 2 bits, replicate sign bit for arithmetic shift
                    // But Booth encoding uses logical shift for multiplier since sign is in multiplicand
                    multiplier <= {2'b00, multiplier[8:2]};
                    step <= step + 1;

                    if (step == 3'd4) begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                    // Hold the output and wait for reset to restart
                    // state stays DONE
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule