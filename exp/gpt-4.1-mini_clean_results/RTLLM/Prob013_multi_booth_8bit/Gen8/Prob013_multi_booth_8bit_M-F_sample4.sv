module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,    // multiplicand
    input      [7:0]   b,    // multiplier
    output reg [15:0]  p,    // product output
    output reg         rdy    // ready signal
);

    // Extended registers
    reg signed [16:0] multiplicand_ext; // 17 bits to allow +/- 2 multiples shifted
    reg [8:0]         multiplier_ext;   // 8 bits multiplier + appended 0 bit for radix-4 booth
    reg signed [31:0] partial_product;  // accumulator for partial products
    reg [2:0]         cycle_cnt;        // counts 0 to 3 (4 cycles)

    // Declare variables for inside always block at module scope
    reg [2:0]         booth_bits;
    integer           sb;
    reg signed [2:0]  mult_factor;
    reg signed [31:0] addend;

    // Booth encoding function: given 3 bits returns signed multiple [-2..+2]
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000,
                3'b111: booth_decode = 3'd0;
                3'b001,
                3'b010: booth_decode = 3'd1;
                3'b011: booth_decode = 3'd2;
                3'b100: booth_decode = -3'd2;
                3'b101,
                3'b110: booth_decode = -3'd1;
                default: booth_decode = 3'd0;
            endcase
        end
    endfunction


    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize registers
            multiplicand_ext <= { {9{a[7]}}, a }; // sign-extend a to 17 bits
            multiplier_ext   <= {b, 1'b0};        // append one zero bit for booth recoding (9 bits)
            partial_product  <= 32'sd0;
            cycle_cnt        <= 3'd0;
            rdy              <= 1'b0;
            p                <= 16'd0;
        end else if (!rdy) begin
            if (cycle_cnt < 3'd4) begin
                sb = cycle_cnt * 2; // start bit

                // bit before start bit, zero if sb == 0
                booth_bits[0] = (sb == 0) ? 1'b0 : multiplier_ext[sb-1];
                booth_bits[1] = multiplier_ext[sb];
                booth_bits[2] = multiplier_ext[sb+1];

                // Decode to multiplier factor (-2..+2)
                mult_factor = booth_decode(booth_bits);

                // Calculate addend = multiplicand_ext * mult_factor shifted by 2*cycle_cnt
                addend = (multiplicand_ext * mult_factor) <<< (2*cycle_cnt);

                // Accumulate
                partial_product <= partial_product + addend;

                // Increment cycle counter
                cycle_cnt <= cycle_cnt + 1'b1;
            end else begin
                // After 4 cycles, multiplication done
                p   <= partial_product[15:0]; // lower 16 bits as product output
                rdy <= 1'b1;
            end
        end
    end

endmodule