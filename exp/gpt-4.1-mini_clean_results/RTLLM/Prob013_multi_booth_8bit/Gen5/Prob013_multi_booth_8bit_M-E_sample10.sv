module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output (lower 16 bits)
    output reg         rdy    // ready signal
);

    // Extend inputs to 9 bits for sign-extension (one extra bit for radix-4 recoding)
    reg signed [8:0] multiplicand;
    reg [8:0] multiplier_ext;  // multiplier extended with an extra zero bit at LSB for Booth grouping

    reg signed [17:0] accumulator; // 18-bit signed accumulator
    reg [2:0]         step;        // 3-bit counter, 4 steps total (0 to 3)

    // Helper function to decode 3-bit booth code to multiplier factor {-2,-1,0,1,2}
    function signed [1:0] booth_decode;
        input [2:0] booth_bits;
        begin
            case (booth_bits)
                3'b000, 3'b111: booth_decode = 2'sd0; // 0
                3'b001, 3'b010: booth_decode = 2'sd1; // +1
                3'b011:          booth_decode = 2'sd2; // +2
                3'b100:          booth_decode = -2'sd2; // -2
                3'b101, 3'b110: booth_decode = -2'sd1; // -1
                default:        booth_decode = 2'sd0;  // default 0 safety
            endcase
        end
    endfunction

    // Extract booth bits for current step
    wire [2:0] booth_bits = { multiplier_ext[2*step+1], multiplier_ext[2*step], (step == 0) ? 1'b0 : multiplier_ext[2*step-1] };

    // Partial product for current step (multiplicand multiplied by booth factor)
    reg signed [17:0] partial_product;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign extend inputs
            multiplicand  <= {a[7], a};
            // Extend multiplier with zero bit at LSB for booth encoding
            multiplier_ext <= {b, 1'b0};
            accumulator   <= 18'sd0;
            step          <= 3'd0;
            p             <= 16'd0;
            rdy           <= 1'b0;
        end else if (!rdy) begin
            // Calculate booth multiplier for current step
            // Decode booth bits to factor (-2 to 2)
            // Compute partial product = multiplicand * factor << (2*step)
            partial_product = multiplicand * booth_decode(booth_bits);
            partial_product = partial_product <<< (2*step);

            accumulator <= accumulator + partial_product;

            if (step == 3) begin
                // Done all 4 steps (8 bits multiplier processed)
                p   <= accumulator[15:0];
                rdy <= 1'b1;
            end else begin
                step <= step + 1;
            end
        end
    end

endmodule