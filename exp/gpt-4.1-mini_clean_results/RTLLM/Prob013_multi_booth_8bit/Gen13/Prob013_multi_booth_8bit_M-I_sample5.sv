module multi_booth_8bit (
    input            clk,
    input            reset,
    input      [7:0] a,      // multiplicand input (called "a" in problem)
    input      [7:0] b,      // multiplier input (called "b" in problem)
    output reg [15:0] p,      // 16-bit product output
    output reg       rdy       // ready signal
);

    // Internal signed 16-bit registers for multiplicand and multiplier
    reg signed [15:0] multiplicand;
    reg signed [15:0] multiplier;

    reg [4:0] ctr; // 5-bit counter for 16 cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize multiplicand and multiplier with sign extension per problem
            multiplier   <= {{8{a[7]}}, a}; // multiplier <= sign-extended a
            multiplicand <= {{8{b[7]}}, b}; // multiplicand <= sign-extended b
            p           <= 16'd0;            // product initialized to zero
            ctr         <= 5'd0;             // reset counter
            rdy         <= 1'b0;             // not ready
        end else if (!rdy) begin
            if (ctr < 16) begin
                // Check the current bit of multiplier at position ctr
                if (multiplier[ctr]) begin
                    // Add shifted multiplicand to product if bit is set
                    p <= p + multiplicand;
                end
                // Left shift multiplicand by 1 for next bit position
                multiplicand <= multiplicand <<< 1;
                // Increment counter
                ctr <= ctr + 1'b1;

                // When done with last bit, set ready
                if (ctr == 15) begin
                    rdy <= 1'b1;
                end
            end
        end
    end

endmodule