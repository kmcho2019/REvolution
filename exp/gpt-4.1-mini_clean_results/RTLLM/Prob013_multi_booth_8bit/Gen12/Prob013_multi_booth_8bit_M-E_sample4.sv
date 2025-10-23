module multi_booth_8bit (
    input          clk,
    input          reset,
    input   [7:0]  a,      // multiplicand (signed)
    input   [7:0]  b,      // multiplier   (signed)
    output reg [15:0] p,   // product
    output reg       rdy    // ready signal
);

    // Internal signals
    reg signed [8:0] multiplicand;       // sign-extended to 9 bits for Booth multiples
    reg [8:0] multiplier;                 // extended multiplier with extra bit for Booth (-1 bit)
    reg signed [17:0] accumulator;       // wider accumulator for partial sums (18 bits)
    reg [2:0] booth_bits;                 // 3 bits window for radix-4 booth recoding
    reg [2:0] step;                      // step counter (0 to 4) for 5 steps total

    // Function to generate Booth multiple of multiplicand according to booth_bits
    // booth_bits encode the operation according to radix-4 Booth recoding:
    // 000 -> 0
    // 001 -> +1 * multiplicand
    // 010 -> +1 * multiplicand
    // 011 -> +2 * multiplicand
    // 100 -> -2 * multiplicand
    // 101 -> -1 * multiplicand
    // 110 -> -1 * multiplicand
    // 111 -> 0
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

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= {a[7], a};           // sign-extend a to 9 bits
            multiplier   <= {b, 1'b0};           // b extended by one zero bit at LSB for Booth recoding (b[-1])
            accumulator  <= 18'sd0;
            step         <= 3'd0;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            if (rdy) begin
                // Wait here until external reset to start a new multiplication
                // Hold outputs and states
                p <= p;
                accumulator <= accumulator;
                multiplicand <= multiplicand;
                multiplier <= multiplier;
                step <= step;
                rdy <= rdy;
            end else if (step < 5) begin
                // Extract 3 bits for Booth recoding: bits [1:0] of multiplier and bit [-1] = previous bit
                // multiplier bits are numbered from LSB = 0
                booth_bits = {multiplier[1:0], multiplier[0]}; 
                // Actually Booth bits should be: {multiplier[1:0], previous bit} but since multiplier is extended with extra bit at LSB=0, we can do:
                booth_bits = multiplier[2:0];  // bits [2:0]

                // Calculate partial product using Booth recoding
                accumulator <= accumulator + (booth_op(booth_bits, multiplicand) <<< (2*step));

                // Shift multiplier right by 2 bits for next step; fill with sign bit for arithmetic shift
                multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

                step <= step + 1;

                if (step == 3'd4) begin
                    // After last step, set output product and ready
                    p <= accumulator[15:0];
                    rdy <= 1'b1;
                end else begin
                    rdy <= 1'b0;
                end
            end
        end
    end

endmodule