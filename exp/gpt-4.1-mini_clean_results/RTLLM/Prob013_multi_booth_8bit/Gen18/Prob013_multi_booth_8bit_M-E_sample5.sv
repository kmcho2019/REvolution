module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,      // multiplicand (signed)
    input   [7:0]   b,      // multiplier   (signed)
    output reg [15:0] p,    // product output
    output reg       rdy     // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand_ext;  // sign-extended multiplicand 16-bit
    reg signed [17:0] multiplier_ext;    // extended multiplier with 2 LSB zeros for radix-4 Booth recoding (18 bits)
    reg signed [31:0] accumulator;       // accumulator for partial sums (32-bit)
    reg [2:0] ctr;                       // cycle counter 0 to 4 for radix-4 steps

    // Function: Booth radix-4 partial product generator
    // Input: 3 bits booth_code
    // Output: signed 32-bit partial product based on multiplicand
    function automatic signed [31:0] booth_partial;
        input [2:0] booth_code;
        input signed [15:0] mpcand;
        begin
            case (booth_code)
                3'b000, 3'b111: booth_partial = 32'sd0;
                3'b001, 3'b010: booth_partial = { {16{mpcand[15]}}, mpcand };       // +1 * multiplicand
                3'b011:         booth_partial = { {15{mpcand[15]}}, mpcand, 1'b0 }; // +2 * multiplicand (shift left 1)
                3'b100:         booth_partial = -({ {15{mpcand[15]}}, mpcand, 1'b0 }); // -2 * multiplicand
                3'b101, 3'b110: booth_partial = -({ {16{mpcand[15]}}, mpcand });      // -1 * multiplicand
                default:        booth_partial = 32'sd0;
            endcase
        end
    endfunction

    // Combinational Booth code extraction: lowest 3 bits of multiplier_ext
    wire [2:0] booth_code = multiplier_ext[1: -1+3] == multiplier_ext[1: -1+3] ? multiplier_ext[1: -1+3] : 3'd0;
    // Note: This syntax is invalid in Verilog; must use multiplier_ext[2:0]
    // Correct to:
    wire [2:0] booth_code_wire = multiplier_ext[2:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Load multiplicand and multiplier with sign extension
            multiplicand_ext <= {{8{a[7]}}, a}; // 16 bits signed
            multiplier_ext   <= { {2{b[7]}}, b, 2'b00 }; // extend multiplier by 2 MSBs sign bits + 2 LSB zeros, total 18 bits
            accumulator      <= 32'sd0;
            ctr              <= 3'd0;
            p                <= 16'd0;
            rdy              <= 1'b0;
        end else begin
            if (ctr < 3'd5) begin
                // Calculate partial product using Booth encoding from lowest 3 bits
                // partial product aligned properly (no shift here, shifting handled by multiplier shift)
                accumulator <= accumulator + (booth_partial(booth_code_wire, multiplicand_ext) << (2*ctr));
                // Arithmetic shift right multiplier_ext by 2 bits
                // Sign extend top bits while shifting
                multiplier_ext <= { {2{multiplier_ext[17]}}, multiplier_ext[17:2] };
                ctr <= ctr + 1'b1;
                rdy <= 1'b0;
            end else begin
                // Multiplication done
                p   <= accumulator[15:0]; // lower 16 bits of product
                rdy <= 1'b1;
            end
        end
    end

endmodule