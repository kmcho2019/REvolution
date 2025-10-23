module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,       // multiplicand
    input      [7:0]   b,       // multiplier
    output reg [15:0]  p,       // product output
    output reg         rdy       // ready signal
);

    // Internal signals and registers
    reg signed [8:0] multiplicand_ext; // 9-bit sign-extended multiplicand for booth multiples
    reg signed [8:0] multiplier_ext;   // 9-bit sign-extended multiplier + one appended zero LSB for booth encoding

    // 32-bit signed accumulator for partial sums (enough width to hold shifted partials)
    reg signed [31:0] accumulator;

    reg [2:0] ctr; // up to 4 iterations needed (0 to 3)
    
    // Booth encoding bits: 3 bits per cycle (overlapping), bits: {prev_bit, curr_bit, next_bit}
    // For iteration i, bits are multiplier_ext[2*i +1 : 2*i -1] (careful with indexing)

    // Function to decode booth multiplier from 3 bits (Radix-4 booth recoding)
    // Encoding: bits = {bit2, bit1, bit0} where bit0 is least significant
    // Mapping:
    // 000 or 111 -> 0
    // 001 or 010 -> +1 * multiplicand
    // 011        -> +2 * multiplicand
    // 100        -> -2 * multiplicand
    // 101 or 110 -> -1 * multiplicand
    // This can be implemented with case statement or lookup

    function signed [9:0] booth_multipler; 
        input [2:0] bits;
        input signed [8:0] mplier;
        begin
            case (bits)
                3'b000,
                3'b111: booth_multipler = 10'sd0;
                3'b001,
                3'b010: booth_multipler = mplier;              // +1 * multiplicand
                3'b011: booth_multipler = mplier <<< 1;        // +2 * multiplicand
                3'b100: booth_multipler = -(mplier <<< 1);     // -2 * multiplicand
                3'b101,
                3'b110: booth_multipler = -mplier;             // -1 * multiplicand
                default: booth_multipler = 10'sd0;
            endcase
        end
    endfunction

    reg [2:0] booth_bits;  // current 3-bit booth code
    reg signed [9:0] partial_product; // partial product output of booth decoding (10 bits: max ±2 * multiplicand 9 bits)

    // State machine for multiplication progress
    // States: IDLE (waiting reset), RUNNING (processing), DONE (holding results)
    localparam IDLE = 2'b00,
               RUN  = 2'b01,
               DONE = 2'b10;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            // On reset:
            // Sign extend inputs to 9 bits (append one zero LSB for multiplier for booth encoding)
            multiplicand_ext <= {a[7], a};        // sign extend to 9 bits
            multiplier_ext   <= {b[7], b, 1'b0};  // sign extend + one zero LSB (9 bits)

            accumulator      <= 32'sd0;
            ctr              <= 3'd0;
            p                <= 16'sd0;
            rdy              <= 1'b0;
            state            <= RUN;
        end else begin
            case(state)
                IDLE: begin
                    // Wait for reset release; do nothing
                    rdy <= 1'b0;
                    p <= 16'sd0;
                end

                RUN: begin
                    if (ctr < 3'd4) begin
                        // Extract booth bits for current iteration:
                        // bits = multiplier_ext[2*ctr +1 : 2*ctr -1]
                        // Need to handle if index < 0, use 0
                        // Note multiplier_ext is 9 bits: [8:0]
                        // Compute indices for bits:
                        // bit0 = multiplier_ext[2*ctr -1] or 0 if <0
                        // bit1 = multiplier_ext[2*ctr]
                        // bit2 = multiplier_ext[2*ctr +1]

                        // Calculate bit indices:
                        integer bit_pos0, bit_pos1, bit_pos2;
                        bit_pos0 = (2*ctr) - 1;
                        bit_pos1 = (2*ctr);
                        bit_pos2 = (2*ctr) + 1;

                        // Extract bits with boundary check
                        // Functionality inside always is restricted, so replicate logic:
                        reg bit0, bit1, bit2;

                        bit0 = (bit_pos0 < 0) ? 1'b0 : multiplier_ext[bit_pos0];
                        bit1 = (bit_pos1 > 8) ? multiplier_ext[8] : multiplier_ext[bit_pos1]; // clamp to msb if out of range
                        bit2 = (bit_pos2 > 8) ? multiplier_ext[8] : multiplier_ext[bit_pos2];

                        booth_bits <= {bit2, bit1, bit0};

                        // Compute partial product via booth_multipler function
                        partial_product <= booth_multipler({bit2, bit1, bit0}, multiplicand_ext);

                        // Add shifted partial product to accumulator
                        // Shift partial product by 2*ctr bits to the left
                        accumulator <= accumulator + ({{22{partial_product[9]}}, partial_product} <<< (2*ctr));

                        ctr <= ctr + 1'b1;
                    end else begin
                        // All 4 iterations done, output product and set ready
                        p <= accumulator[15:0];
                        rdy <= 1'b1;
                        state <= DONE;
                    end
                end

                DONE: begin
                    // Hold output stable, ready asserted until next reset
                    rdy <= 1'b1;
                    // p holds final product
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule