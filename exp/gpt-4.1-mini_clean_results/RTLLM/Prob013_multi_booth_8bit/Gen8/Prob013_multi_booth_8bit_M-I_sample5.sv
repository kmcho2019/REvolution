module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    reg [4:0] ctr;  // 5-bit counter for up to 8 cycles (we only use up to 4 cycles)
    
    // Registers as specified: sign-extend inputs to 16 bits
    reg [15:0] multiplicand;
    reg [17:0] multiplier_ext; // multiplier extended with one extra zero bit at LSB for Booth encoding
    
    // Internal partial product
    reg signed [17:0] partial_product; 
    
    // Intermediate value for Booth code (3 bits)
    reg [2:0] booth_code;
    
    // Function to get multiple of multiplicand according to Booth code
    function signed [17:0] booth_multiply;
        input [2:0] code;
        input signed [15:0] m;  // multiplicand
        begin
            case(code)
                3'b000,
                3'b111: booth_multiply = 18'sd0;        // 0
                3'b001,
                3'b010: booth_multiply = { {2{m[15]}}, m}; // +1 * M (sign-extend to 18 bits)
                3'b011: booth_multiply = ({ {2{m[15]}}, m} << 1); // +2 * M
                3'b100: booth_multiply = -({ {2{m[15]}}, m} << 1); // -2 * M
                3'b101,
                3'b110: booth_multiply = -({ {2{m[15]}}, m});       // -1 * M
                default: booth_multiply = 18'sd0; // safety
            endcase
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize multiplicand and multiplier with sign extension
            multiplicand <= { {8{a[7]}}, a };
            // multiplier_ext is multiplier with an appended zero bit at LSB for Booth encoding
            multiplier_ext <= { {8{b[7]}}, b, 1'b0 };
            p <= 16'd0;
            ctr <= 5'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5) begin
                // Extract 3 bits for Booth encoding: bits [2:0] of multiplier_ext
                booth_code = multiplier_ext[2:0];
                // Get partial product according to Booth code and multiplicand
                partial_product = booth_multiply(booth_code, multiplicand);
                // Accumulate partial product shifted by 2*ctr bits (as radix-4 processes 2 bits per iteration)
                // Since partial_product is 18 bits, shift left by 2*ctr
                // Accumulate lower 16 bits into p, but since we want exact result, accumulate all and truncate later
                // Use a wider accumulator internally by extending p to 18 bits for accumulation
                // We'll maintain p as 16 bits output, but internally use an 18-bit signed register for accumulation
                // To avoid complexity, use a separate accumulator register
                
                // Implement accumulator as a signed 18-bit register internally:
                // We'll create internal reg for accumulator outside this always block
            end
        end
    end

    // Internal 18-bit signed accumulator to hold sum of partial products
    reg signed [17:0] acc;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            acc <= 18'sd0;
        end else if (!rdy) begin
            if (ctr < 5) begin
                // Extract 3 bits for Booth encoding: bits [2:0] of multiplier_ext
                booth_code = multiplier_ext[2:0];
                // Calculate partial product
                partial_product = booth_multiply(booth_code, multiplicand);
                // Accumulate partial product shifted left by 2*ctr
                acc <= acc + (partial_product <<< (2*ctr));
                
                // Shift multiplier right by 2 bits for next iteration
                multiplier_ext <= multiplier_ext >> 2;
                ctr <= ctr + 1;
            end
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            if (ctr == 5) begin
                // Assign lower 16 bits of accumulator to output product
                p <= acc[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule