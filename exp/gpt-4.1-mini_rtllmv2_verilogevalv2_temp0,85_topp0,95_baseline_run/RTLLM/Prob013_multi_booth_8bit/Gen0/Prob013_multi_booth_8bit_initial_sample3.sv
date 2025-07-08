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
    reg [4:0] ctr; // 5-bit counter to count up to 16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, load inputs with sign extension
            multiplicand <= {{8{b[7]}}, b};
            multiplier   <= {{8{a[7]}}, a};
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // If multiplier bit at ctr is 1, accumulate multiplicand into p
                if (multiplier[ctr] == 1'b1) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1 (multiply by 2)
                multiplicand <= multiplicand << 1;
                // Increment counter
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Done multiplication
                rdy <= 1'b1;
            end
        end
    end

endmodule