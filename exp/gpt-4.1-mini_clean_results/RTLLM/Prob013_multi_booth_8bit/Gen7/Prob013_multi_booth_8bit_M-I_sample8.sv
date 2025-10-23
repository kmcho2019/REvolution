module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplier input
    input      [7:0]  b,        // multiplicand input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // States
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    // Extended registers for arithmetic: 
    // multiplier extended with extra zero bit LSB for Booth encoding
    reg signed [9:0] multiplier_ext;    // 8 bits + 2 zeros for scanning 3 bits each step
    reg signed [16:0] product;           // 17 bits to accommodate overflow
    reg signed [15:0] multiplicand;

    reg [2:0] cycle_ctr; // 3 bits sufficient: 0 to 3 (4 cycles)

    // Booth recoding function: input 3 bits, output multiplier factor (-2..2)
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 3'd0;
                3'b001, 3'b010: booth_decode = 3'd1;
                3'b011:         booth_decode = 3'd2;
                3'b100:         booth_decode = -3'd2; // -2
                3'b101, 3'b110: booth_decode = -3'd1; // -1
                default:        booth_decode = 3'd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Load inputs sign-extended
            multiplicand    <= {b[7], b, 7'b0}; // b extended to 15 bits left shifted by 7 bits? No, let's just sign-extend 16 bits
            multiplicand    <= { {8{b[7]}}, b };
            // Prepare multiplier_ext with appended 1 zero bit at LSB (for Booth encoding)
            multiplier_ext  <= { {2{a[7]}}, a, 1'b0 }; 
            product         <= 17'sd0;
            cycle_ctr       <= 3'd0;
            rdy             <= 1'b0;
            p               <= 16'd0;
            state           <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // Start multiplication immediately after reset release
                    rdy       <= 1'b0;
                    cycle_ctr <= 3'd0;
                    product   <= 17'sd0;
                    state     <= BUSY;
                end

                BUSY: begin
                    if (cycle_ctr < 3'd4) begin
                        // Extract current 3 bits for Booth encoding
                        // bits = multiplier_ext[1: -1] for cycle 0, etc. We pick bits [2*cycle+1 : 2*cycle -1]
                        // But we always process multiplier_ext[2*cycle +: 3]
                        // To simplify indexing, we shift multiplier_ext right by 2*cycle bits and take 3 LSB bits
                        // Because multiplier_ext width is 10 bits, and cycles 0..3
                        // calculate bits:
                        reg [2:0] booth_bits;
                        booth_bits = multiplier_ext[2*cycle_ctr +: 3];

                        // Decode booth_bits to multiplier factor
                        reg signed [2:0] m_factor;
                        m_factor = booth_decode(booth_bits);

                        // Calculate partial product to add: multiplicand * m_factor shifted by 2*cycle bits
                        // multiplicand is 16 bits signed
                        // m_factor is -2..2
                        // product is 17 bits signed
                        // partial product width = 16 + 2 + 1 bits = at least 19 bits (for shifts and multiples)
                        reg signed [18:0] partial;
                        partial = (multiplicand * m_factor);
                        partial = partial <<< (2*cycle_ctr);

                        product <= product + partial;

                        cycle_ctr <= cycle_ctr + 1'b1;
                    end else begin
                        // done
                        p <= product[15:0]; // low 16 bits is the product
                        rdy <= 1'b1;
                        state <= IDLE; // or stay in IDLE waiting for reset or new inputs
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule