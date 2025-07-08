module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign extend inputs and initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'd0;
            ctr <= 5'd0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // If current multiplier bit is 1, add multiplicand to p
                if (multiplier[ctr] == 1'b1) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 for next bit
                multiplicand <= multiplicand << 1;
                // Increment counter
                ctr <= ctr + 1;
                // Ready signal low during operation
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule