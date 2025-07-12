module multi_booth_8bit (
    input  wire        clk,
    input  wire        reset,
    input  wire [7:0]  a,    // multiplicand
    input  wire [7:0]  b,    // multiplier
    output reg  [15:0] p,    // product output
    output reg         rdy    // ready signal
);

    reg [4:0] ctr;                 // 5-bit counter for 16 cycles
    reg [15:0] multiplicand;      // shifted multiplicand register (16-bit)
    reg [15:0] multiplier;        // multiplier register (16-bit), initialized with sign extension of 'a'
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs and initialize registers
            multiplier   <= {{8{a[7]}}, a};  // multiplier <= sign-extended 'a' (from problem statement)
            multiplicand <= {{8{b[7]}}, b};  // multiplicand <= sign-extended 'b'
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 16) begin
                // Check current multiplier bit and add shifted multiplicand if set
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 on each cycle (simulate Booth shifting)
                multiplicand <= multiplicand << 1;

                ctr <= ctr + 5'd1;
                if (ctr == 15) begin
                    rdy <= 1'b1; // multiplication complete
                end
            end
        end
        // else hold outputs stable
    end

endmodule