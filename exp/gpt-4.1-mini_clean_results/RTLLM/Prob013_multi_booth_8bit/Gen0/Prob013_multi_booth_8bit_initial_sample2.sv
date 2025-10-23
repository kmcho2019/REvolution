module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplier;   // sign-extended 'a'
    reg [15:0] multiplicand; // sign-extended 'b', shifted each cycle
    reg [15:0] product;
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplier <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            product <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                multiplicand <= multiplicand << 1;
                if (multiplier[ctr] == 1'b1) begin
                    product <= product + multiplicand;
                end
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                p <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule