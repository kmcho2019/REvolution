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

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= {{8{a[7]}}, a};  // sign-extend a to 16 bits
            multiplier <= {{8{b[7]}}, b};    // sign-extend b to 16 bits
            p <= 16'b0;
            ctr <= 0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                if (multiplier[ctr] == 1'b1) begin
                    p <= p + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
                if (ctr == 15) begin
                    rdy <= 1'b1;
                end
            end
        end
    end

endmodule