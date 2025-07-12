module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,     // multiplicand
    input  wire [7:0]  b,     // multiplier
    output reg  [15:0] p,     // product output
    output reg         rdy     // ready signal
);

    reg [4:0] ctr;              // 5-bit counter from 0 to 16
    reg [15:0] multiplicand;    // sign-extended multiplicand register
    reg [15:0] multiplier;      // sign-extended multiplier register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs and initialize registers and signals
            multiplicand <= {{8{a[7]}}, a};
            multiplier   <= {{8{b[7]}}, b};
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // For each bit in multiplier, if bit is 1 add current multiplicand to p
                if (multiplier[0] == 1'b1)
                    p <= p + multiplicand;

                // Shift multiplicand left by 1 to prepare for next bit
                multiplicand <= multiplicand << 1;

                // Shift multiplier right logically by 1 to get next multiplier bit at LSB
                multiplier <= multiplier >> 1;

                // Increment counter
                ctr <= ctr + 1;

                // Clear ready during operation
                rdy <= 1'b0;
            end else begin
                // When all 16 bits processed, assert ready
                rdy <= 1'b1;
            end
        end
    end

endmodule