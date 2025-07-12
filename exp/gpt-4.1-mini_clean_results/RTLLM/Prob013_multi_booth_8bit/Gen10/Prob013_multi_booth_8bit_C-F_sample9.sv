module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplier input (multiplicand)
    input      [7:0]   b,      // multiplicand input (multiplier)
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;
    reg state;

    // Signed extended registers: 
    // multiplicand extended to 16 bits signed for arithmetic,
    // multiplier extended to 17 bits (with extra LSB 0 for Booth recoding)
    reg signed [15:0] multiplicand;        // multiplicand (a) sign-extended 16-bit
    reg signed [16:0] multiplier_ext;      // multiplier (b) extended by 1 LSB zero bit (17 bits)
    
    reg signed [31:0] product;             // accumulator for product, 32-bit to hold intermediate sum shifted
    reg [3:0] ctr;                         // 4-bit counter: 8 iterations (Radix-4 processes 2 bits per iteration)

    // Internal signal for booth encoding bits
    reg [2:0] booth_bits;

    // Calculate the partial product term based on the Booth encoding
    // Returns signed [17:0] partial product (2x multiplicand max), will be shifted and added to product
    function signed [17:0] booth_encode;
        input [2:0] bits;
        input signed [15:0] mplier;
        begin
            case (bits)
                3'b000, 3'b111: booth_encode = 18'sd0;
                3'b001, 3'b010: booth_encode = {mplier, 1'b0} >>> 1; // +1*mplier (shifted to align later)
                3'b011:         booth_encode = {mplier, 1'b0};       // +2*mplier
                3'b100:         booth_encode = -({mplier, 1'b0});      // -2*mplier
                3'b101, 3'b110: booth_encode = -(({mplier, 1'b0} >>> 1)); // -1*mplier
                default:        booth_encode = 18'sd0;
            endcase
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // Load and sign-extend multiplicand (a)
            multiplicand    <= { {8{a[7]}}, a };  
            // Load multiplier (b) extended with extra LSB zero for Booth recode
            multiplier_ext  <= {b, 1'b0};          // 8 bits + 1 LSB zero
            product         <= 32'sd0;
            ctr             <= 4'd0;
            rdy             <= 1'b0;
            p               <= 16'd0;
            state           <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    product <= 32'sd0;
                    ctr <= 4'd0;
                    state <= BUSY;
                end
                BUSY: begin
                    if (ctr < 4'd8) begin
                        // Select 3 bits of multiplier for Booth encoding: bits [2*ctr+1 : 2*ctr-1]
                        // To avoid negative index when ctr=0 (2*0-1=-1), we pad multiplier_ext with an extra 0 at LSB
                        // multiplier_ext indexing:
                        // For ctr=0: bits [1:0] + bit -1 assumed 0 --> so use bits [1:0] plus assumed zero for -1
                        // To simplify, multiplier_ext is 17 bits with one extra LSB zero.
                        // So bits are [2*ctr+1 : 2*ctr-1], safe since multiplier_ext[0] is zero.
                        booth_bits = multiplier_ext[(2*ctr)+1 -: 3];

                        // Calculate Booth encoded partial product (signed 18 bits)
                        // Then shift it left by 2*ctr bits to align with product bits
                        // partial = booth_encode * (multiplicand), aligned by position
                        // Shift partial left by 2*ctr before adding to product
                        product <= product + ( ( $signed(booth_encode(booth_bits, multiplicand)) ) <<< (2*ctr) );

                        ctr <= ctr + 1;
                    end else begin
                        // Assign lower 16 bits of product as output
                        p <= product[15:0];
                        rdy <= 1'b1;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule