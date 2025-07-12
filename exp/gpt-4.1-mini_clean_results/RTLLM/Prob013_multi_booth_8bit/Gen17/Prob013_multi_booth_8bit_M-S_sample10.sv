module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,    // multiplier input
    input      [7:0]  b,    // multiplicand input
    output reg [15:0] p,    // product output
    output reg        rdy    // ready signal
);

    reg [15:0] multiplier;    // holds sign-extended multiplier (a)
    reg [15:0] multiplicand;  // holds sign-extended multiplicand (b)
    reg [15:0] product;       // accumulation register
    reg [4:0]  ctr;           // 5-bit counter for 16 cycles

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplier   <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            product      <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else begin
            if (ctr < 5'd16) begin
                if (multiplier[ctr])
                    product <= product + multiplicand;
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1'b1;
                rdy <= 1'b0;
            end else begin
                p   <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule