module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,      // multiplicand
    input  wire [7:0]  b,      // multiplier
    output reg  [15:0] p,      // product output
    output reg         rdy      // ready signal
);

    reg [4:0] ctr;                   // 5-bit counter for iterations (0 to 16)
    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg [15:0] multiplier;          // multiplier register (zero/sign-extended)
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers: sign-extend inputs
            multiplicand <= {{8{a[7]}}, a};
            multiplier   <= {{8{b[7]}}, b};
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr])
                    p <= p + multiplicand;
                // Shift multiplicand left by 1 for next bit weighting
                multiplicand <= multiplicand <<< 1;
                // Increment counter
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Multiplication done, set ready signal
                rdy <= 1'b1;
            end
        end
    end

endmodule