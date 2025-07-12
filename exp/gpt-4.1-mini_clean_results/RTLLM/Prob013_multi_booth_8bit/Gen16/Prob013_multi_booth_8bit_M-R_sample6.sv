module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    // Internal registers
    reg signed [8:0] multiplicand;      // multiplicand sign-extended to 9 bits
    reg [8:0]        multiplier;        // multiplier extended with one LSB zero for Booth recoding
    reg signed [17:0] accumulator;      // 18-bit signed accumulator for partial sums

    reg [2:0] ctr;                      // counter for 5 iterations (0 to 4)
    reg busy;                          // busy flag indicating multiplication in progress

    wire [2:0] booth_bits;
    assign booth_bits = multiplier[2:0];  // current 3 bits for Booth encoding

    // Booth operation: outputs signed partial product for current 3-bit code and multiplicand
    function signed [17:0] booth_op;
        input [2:0] bits;
        input signed [8:0] mpcand;
        reg signed [17:0] val;
        begin
            case(bits)
                3'b000, 3'b111: val = 18'sd0;
                3'b001, 3'b010: val = { {9{mpcand[8]}}, mpcand };          // +1 * multiplicand
                3'b011:        val = { {8{mpcand[8]}}, mpcand, 1'b0 };    // +2 * multiplicand (shift left 1)
                3'b100:        val = -({ {8{mpcand[8]}}, mpcand, 1'b0 });  // -2 * multiplicand
                3'b101, 3'b110: val = -({ {9{mpcand[8]}}, mpcand });       // -1 * multiplicand
                default:       val = 18'sd0;
            endcase
            booth_op = val;
        end
    endfunction

    // On reset, initialize registers
    // On normal operation: when not busy, initialize registers and start multiplication
    // When busy, perform one Booth step per clock cycle, shift multiplier, accumulate partial product
    // After 5 iterations (8 bits / radix-4 = 5 steps), set ready high and output product

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {a[7], a};        // sign-extend multiplicand
            multiplier   <= {b, 1'b0};        // extend multiplier with zero LSB
            accumulator  <= 18'sd0;
            ctr         <= 3'd0;
            busy        <= 1'b1;
            rdy         <= 1'b0;
            p           <= 16'd0;
        end else begin
            if (busy) begin
                // Accumulate partial product shifted by 2*ctr bits (left shift)
                accumulator <= accumulator + (booth_op(booth_bits, multiplicand) <<< (2*ctr));

                // Arithmetic right shift multiplier by 2 bits (sign-extend)
                multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                ctr <= ctr + 1'b1;

                if (ctr == 3'd4) begin
                    // Last step completed (5 steps total)
                    p   <= accumulator[15:0];
                    rdy <= 1'b1;
                    busy <= 1'b0;
                end else begin
                    rdy <= 1'b0;
                end
            end else begin
                // Idle: keep outputs stable; to restart, external logic must assert reset
                rdy <= 1'b1;
                p <= p;
            end
        end
    end

endmodule