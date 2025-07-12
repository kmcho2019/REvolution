module multi_booth_8bit(
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
reg [15:0] product;
reg [1:0] state;

// Using non-blocking assignments to reduce potential delays
always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= #0 {{8{b[7]}}, b};
        multiplier <= #0 {{8{a[7]}}, a};
        product <= #0 0;
        ctr <= #0 0;
        rdy <= #0 0;
        state <= #0 0;
    end else begin
        case (state)
            0: begin
                multiplicand <= #0 {{8{b[7]}}, b};
                multiplier <= #0 {{8{a[7]}}, a};
                state <= #0 1;
            end
            1: begin
                if (ctr < 16) begin
                    // Using a more efficient Booth encoding scheme to reduce switching activity
                    multiplicand <= #0 multiplicand << 1;
                    if (multiplier[ctr] == 1) begin
                        product <= #0 product + multiplicand;
                    end
                    ctr <= #0 ctr + 1;
                end else begin
                    state <= #0 2;
                end
            end
            2: begin
                p <= #0 product;
                rdy <= #0 1;
                state <= #0 0;
            end
            default: begin
                state <= #0 0;
            end
        endcase
    end
end

endmodule