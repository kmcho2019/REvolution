module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand
    input      [7:0]   b,      // multiplier
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    // Extended multiplier with appended zero bit for Booth recoding
    reg [8:0] multiplier_ext;   // multiplier + one zero bit LSB

    // Registers for multiplicand and product, signed for arithmetic
    reg signed [15:0] multiplicand;
    reg signed [16:0] product;  // 17-bit to hold overflow during accumulation

    reg [2:0] ctr;             // 3-bit counter, max 5 iterations (0 to 4)

    // Function to perform Booth recode and return partial multiplicand multiple
    function signed [16:0] booth_mux;
        input [2:0] bits;                // 3 bits for Booth recode
        input signed [15:0] mpd;        // multiplicand
        begin
            case (bits)
                3'b000,
                3'b111: booth_mux = 17'sd0;             // 0
                3'b001,
                3'b010: booth_mux = {mpd[15], mpd};     // +1 * multiplicand
                3'b011: booth_mux = {mpd[15], mpd} << 1;// +2 * multiplicand
                3'b100: booth_mux = -({mpd[15], mpd} << 1);// -2 * multiplicand
                3'b101,
                3'b110: booth_mux = -{mpd[15], mpd};    // -1 * multiplicand
                default: booth_mux = 17'sd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // On reset, load inputs with sign extension and initialize
            multiplicand    <= {a[7], a};
            multiplier_ext  <= {b, 1'b0};  // multiplier with appended 0 LSB
            product         <= 17'sd0;
            ctr             <= 3'd0;
            rdy             <= 1'b0;
            p               <= 16'd0;
            state           <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    // Start multiplication immediately after reset release
                    rdy <= 1'b0;
                    product <= 17'sd0;
                    ctr <= 3'd0;
                    state <= BUSY;
                end
                BUSY: begin
                    if (ctr < 3'd5) begin
                        // Extract 3 bits from multiplier_ext for Radix-4 Booth
                        // bits = multiplier_ext[2*ctr+1 : 2*ctr-1]
                        // Take care for ctr=0: bits [1: -1], extend with zero if index < 0
                        reg [2:0] recode_bits;
                        integer low_bit_idx;
                        low_bit_idx = 2*ctr - 1;
                        if (low_bit_idx < 0) begin
                            // bits[2] = multiplier_ext[2*ctr+1]
                            // bits[1] = multiplier_ext[2*ctr]
                            // bits[0] = 0 (beyond LSB)
                            recode_bits[2] = multiplier_ext[2*ctr+1];
                            recode_bits[1] = multiplier_ext[2*ctr];
                            recode_bits[0] = 1'b0;
                        end else begin
                            recode_bits = multiplier_ext[2*ctr+1 -: 3];
                        end

                        // Calculate partial product using Booth recoding
                        // Shift product right by 2 bits to prepare for next addition
                        // Since we accumulate product += partial_mult * 2^(2*ctr)
                        // We'll shift product right before add, or shift multiplicand accordingly.

                        // In this approach, product accumulates partial sums shifted appropriately.
                        // But since we process LSB to MSB, we can add partial product shifted left by 2*ctr

                        // Calculate partial product to add
                        reg signed [16:0] partial_mult;
                        partial_mult = booth_mux(recode_bits, multiplicand);

                        // Add partial product shifted left by 2*ctr (0,2,4,6,8)
                        product <= product + (partial_mult <<< (2*ctr));

                        ctr <= ctr + 1'b1;
                    end else begin
                        // Multiplication done
                        p <= product[15:0];  // truncate to 16 bits (least significant)
                        rdy <= 1'b1;
                        state <= IDLE;       // Return to IDLE and wait for next reset/start
                    end
                end
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule