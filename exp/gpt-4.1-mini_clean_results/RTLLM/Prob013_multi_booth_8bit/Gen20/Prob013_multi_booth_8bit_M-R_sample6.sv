module multi_booth_8bit (
    input            clk,
    input            reset,
    input      [7:0] a,        // multiplicand (signed)
    input      [7:0] b,        // multiplier (signed)
    output reg [15:0] p,       // product output
    output reg       rdy        // ready signal
);

    // Internal registers
    reg signed [8:0] multiplicand;    // Sign-extended multiplicand (9 bits)
    reg signed [8:0] multiplier;      // Multiplier with extra appended bit (9 bits)
    reg signed [17:0] accumulator;    // Accumulator (partial product sum), 18 bits
    reg [2:0] step;                   // Step counter (0 to 4)
    reg running;                     // Indicates multiplication in progress

    wire [2:0] booth_bits = multiplier[2:0];  // 3 LSBs for Booth encoding

    wire signed [17:0] booth_pp;     // Partial product from booth partial product generator

    // Booth partial product generation module instance
    booth_pp_gen booth_pp_inst (
        .bits(booth_bits),
        .multiplicand(multiplicand),
        .pp(booth_pp)
    );

    always @(posedge clk) begin
        if (reset) begin
            // Initialize on reset: load multiplicand and multiplier with sign extension and appended bit
            multiplicand <= {a[7], a};    // sign-extend to 9 bits
            multiplier   <= {b, 1'b0};    // append zero bit for Booth algorithm
            accumulator  <= 18'sd0;
            step         <= 3'd0;
            running      <= 1'b1;
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (running) begin
            // Accumulate shifted partial product
            accumulator <= accumulator + (booth_pp <<< (2*step));

            // Arithmetic right shift multiplier by 2 bits with sign extension
            multiplier <= { {2{multiplier[8]}}, multiplier[8:2] };

            // Increment step counter
            step <= step + 3'd1;

            // Check if last step (5 steps for 8-bit Radix-4)
            if (step == 3'd4) begin
                // Output final product and signal ready
                p   <= accumulator[15:0];
                rdy <= 1'b1;
                running <= 1'b0;  // multiplication done
            end
        end else begin
            // Hold outputs stable when not running and not reset
            rdy <= rdy;
            p   <= p;
        end
    end

endmodule

// Booth partial product generator module
module booth_pp_gen (
    input      [2:0]       bits,          // 3-bit Booth encoding bits
    input signed [8:0]     multiplicand,  // 9-bit signed multiplicand
    output reg signed [17:0] pp            // 18-bit signed partial product output
);
    reg signed [17:0] mpcand_ext;
    reg signed [17:0] mpcand_x2;
    always @(*) begin
        mpcand_ext = {{9{multiplicand[8]}}, multiplicand}; // sign extend to 18 bits
        mpcand_x2  = mpcand_ext <<< 1;                   // multiplicand * 2

        case (bits)
            3'b000, 3'b111: pp = 18'sd0;
            3'b001, 3'b010: pp = mpcand_ext;      // +1 * multiplicand
            3'b011:         pp = mpcand_x2;       // +2 * multiplicand
            3'b100:         pp = -mpcand_x2;      // -2 * multiplicand
            3'b101, 3'b110: pp = -mpcand_ext;     // -1 * multiplicand
            default:        pp = 18'sd0;
        endcase
    end
endmodule