module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand input
    input      [7:0]   b,      // multiplier input
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;

    reg state;

    // Extend multiplier by appending 0 at LSB to help Booth encoding
    // Store multiplier and multiplicand as signed 17-bit to accommodate sign and shifts
    reg signed [16:0] multiplier;    // {b[7:0],0}, sign-extended implicitly for arithmetic
    reg signed [16:0] multiplicand;  // sign-extended multiplicand
    reg signed [33:0] product;       // extended product register, 34 bits to hold shifted accumulations
    // The product is wider to hold accumulation before final truncation

    reg [3:0] ctr;                   // 4-bit counter (0..7 for 8 cycles)

    // Function to perform radix-4 Booth recoding on 3 bits
    // Returns the multiplier factor for multiplicand: -2,-1,0,1,2
    function signed [1:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000, 3'b111: booth_decode = 2'sd0;   // 0
                3'b001, 3'b010: booth_decode = 2'sd1;   // +1
                3'b011:         booth_decode = 2'sd2;   // +2
                3'b100:         booth_decode = -2'sd2;  // -2 (two's complement of 2)
                3'b101, 3'b110: booth_decode = -2'sd1;  // -1
                default:        booth_decode = 2'sd0;
            endcase
        end
    endfunction

    // Helper function to sign-extend 8-bit input to 17 bits (for multiplicand)
    function signed [16:0] sign_ext_8_to_17;
        input [7:0] in8;
        begin
            sign_ext_8_to_17 = {{9{in8[7]}}, in8};
        end
    endfunction

    // Helper function to sign-extend 8-bit input to 17 bits (for multiplier with appended zero)
    function signed [16:0] sign_ext_mult;
        input [7:0] in8;
        begin
            // Append 0 as LSB for booth encoding
            sign_ext_mult = {{8{in8[7]}}, in8, 1'b0};
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= sign_ext_8_to_17(a);
            multiplier   <= sign_ext_mult(b);
            product      <= 34'sd0;
            ctr          <= 4'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
            state        <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    // Start multiplication immediately after reset deasserted
                    rdy <= 1'b0;
                    product <= 34'sd0;
                    ctr <= 4'd0;
                    state <= BUSY;
                end

                BUSY: begin
                    if (ctr < 4'd8) begin
                        // Extract 3 bits for current Radix-4 booth encoding
                        // For iteration i, bits are multiplier[2i+1:2i-1]
                        // For i=0, multiplier[-1] assumed 0 by prepending 0 in the shift register
                        // Here we have appended one zero LSB, so index is safe
                        // We'll build bits as: {multiplier[2*ctr+1], multiplier[2*ctr], multiplier[2*ctr-1]}
                        // For ctr=0, bit -1 = 0
                        reg [2:0] booth_bits;
                        reg signed [1:0] mult_factor;
                        reg signed [33:0] partial_product;

                        // Get bits safely, multiplier index max 16 (since multiplier is 17 bits)
                        // bit_minus1 = (2*ctr == 0)? 0 : multiplier[2*ctr-1]
                        booth_bits[0] = (2*ctr == 0) ? 1'b0 : multiplier[(2*ctr)-1];
                        booth_bits[1] = multiplier[2*ctr];
                        booth_bits[2] = multiplier[(2*ctr)+1];

                        // Decode Booth bits to multiplicand multiple (-2, -1, 0, 1, 2)
                        mult_factor = booth_decode(booth_bits);

                        // Calculate partial product: multiplicand * mult_factor
                        // mult_factor is signed 2-bit (-2 to +2)
                        partial_product = multiplicand * mult_factor;

                        // Shift partial product by 2*ctr (since Radix-4 processes 2 bits per cycle)
                        product <= product + (partial_product <<< (2*ctr));

                        // Increment counter
                        ctr <= ctr + 1;
                    end else begin
                        // Done multiplying after 8 cycles
                        // Truncate product to 16 bits and assign output
                        p <= product[15:0];
                        rdy <= 1'b1;
                        state <= IDLE;  // Ready for next multiplication after reset or new start
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule