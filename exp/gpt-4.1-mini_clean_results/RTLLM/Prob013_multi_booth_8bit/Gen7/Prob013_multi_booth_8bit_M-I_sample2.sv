module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    reg [4:0] ctr;  // 5-bit counter for 16 cycles

    // Registers as specified: multiplier and multiplicand are 16 bits sign-extended
    reg [15:0] multiplicand; // left shifted each cycle
    reg [15:0] multiplier;   // fixed register holding multiplier extended

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize multiplicand and multiplier with sign-extension
            multiplicand <= { {8{a[7]}}, a };
            multiplier   <= { {8{b[7]}}, b };
            p            <= 16'b0;
            ctr          <= 5'b0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            // At each cycle (ctr < 16)
            if (ctr < 16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr] == 1'b1) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 for next cycle
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1'b1;
            end
            
            // When counter reaches 16, multiplication is done
            if (ctr == 16) begin
                rdy <= 1'b1;
            end
        end
    end

endmodule