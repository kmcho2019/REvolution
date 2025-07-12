module multi_booth_8bit (
    input           clk,
    input           reset,
    input   [7:0]   a,      // multiplicand
    input   [7:0]   b,      // multiplier
    output reg [15:0] p,    // product output
    output reg      rdy      // ready flag
);

    // Internal registers
    reg signed [16:0] multiplicand;  // sign-extended multiplicand (8 + 9 bits)
    reg [17:0] multiplier;            // multiplier with appended zero bit (8 + 1 + 9 bits to safely extract bits)
    reg signed [33:0] product;        // enough bits to hold partial sums (17 + 17)
    reg [2:0] count;                  // cycle counter (0 to 4 for 4 cycles)

    // Extract current 3 bits for Booth recoding: bits [1:0] plus bit -1 (appended zero)
    // We'll keep multiplier with one extra zero bit at LSB (bit 0)
    wire [2:0] booth_bits = multiplier[1:0] | (multiplier[2] << 2) ? multiplier[2:0] : multiplier[2:0]; // just multiplier[2:0]

    // Booth operation factor: based on 3 bits (multiplier[count*2 + 1 : count*2 - 1]) but we keep multiplier shifted each cycle
    // Simplify by looking at bits [1:0] plus previous bit (which is kept as LSB zero)
    // We'll always consider multiplier[1:0] and multiplier[-1] = 0

    // Decode function inline: bits - [2] is MSB, [1] middle, [0] LSB
    // 000 or 111:  0
    // 001 or 010: +1
    // 011:        +2
    // 100:        -2
    // 101 or 110: -1
    // Implement as simple case

    // For radix-4, process 2 bits each cycle, total 4 cycles

    // Implement decoding inline in always block

    always @(posedge clk) begin
        if (reset) begin
            multiplicand <= { {9{a[7]}}, a };       // sign extend 8-bit multiplicand to 17 bits
            multiplier   <= {b, 1'b0};               // append zero LSB bit for Booth encoding (9 bits)
            product      <= 34'd0;                   // clear product accumulator
            count        <= 3'd0;                    // reset count
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (!rdy) begin
            // Decode booth_bits
            // booth_bits = multiplier[1:0] + multiplier[-1], we have multiplier[2:0] for safe access:
            // bits = multiplier[2:0]
            reg signed [2:0] factor;
            case (multiplier[2:0])
                3'b000,
                3'b111: factor =  3'sd0;
                3'b001,
                3'b010: factor =  3'sd1;
                3'b011: factor =  3'sd2;
                3'b100: factor = -3'sd2;
                3'b101,
                3'b110: factor = -3'sd1;
                default: factor = 3'sd0;
            endcase

            // Calculate partial product to add/subtract (shift multiplicand by count*2 bits)
            // Shift multiplicand by count*2 bits left, then multiply by factor
            reg signed [33:0] partial;
            partial = factor * (multiplicand <<< (count*2));

            // Accumulate partial product
            product <= product + partial;

            // Shift multiplier right by 2 bits for next cycle
            multiplier <= multiplier >> 2;

            // Increment count
            count <= count + 1'b1;

            // Check if done after 4 cycles
            if (count == 3'd3) begin
                p <= product[15:0];  // Output lower 16 bits as product
                rdy <= 1'b1;
            end
        end else begin
            // Hold ready high until reset
            rdy <= 1'b1;
        end
    end

endmodule