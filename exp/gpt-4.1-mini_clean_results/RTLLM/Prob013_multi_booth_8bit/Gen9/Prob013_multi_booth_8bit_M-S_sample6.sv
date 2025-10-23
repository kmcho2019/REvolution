module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand input
    input      [7:0]   b,      // multiplier input
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    reg [15:0] multiplicand;   // multiplicand register (sign-extended)
    reg [16:0] multiplier;     // multiplier extended with one bit LSB for Booth recoding (9 bits + zeros in upper)
    reg [4:0]  ctr;            // 5-bit counter (0 to 16)

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // sign extend multiplicand to 16 bits
            multiplicand <= {{8{a[7]}}, a};
            // sign extend multiplier b and add one zero bit LSB for Booth
            multiplier <= {{8{1'b0}}, b, 1'b0}; // upper bits zero since problem states so
            p <= 16'd0;
            ctr <= 5'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 5'd16) begin
                // Check current bit of multiplier at position ctr (the bit "multiplier[ctr]").
                // If multiplier[ctr] == 1, add multiplicand to p
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // shift multiplicand left by 1
                multiplicand <= multiplicand << 1;
                // increment counter
                ctr <= ctr + 1;
            end else begin
                // multiplication done
                rdy <= 1'b1;
            end
        end
    end

endmodule