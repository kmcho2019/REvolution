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
reg state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                if (a!= 0 || b!= 0) begin
                    multiplicand <= {{8{b[7]}}, b};
                    multiplier <= {{8{a[7]}}, a};
                    state <= 1;
                end
            end
            1: begin
                if (ctr < 16) begin
                    multiplicand <= multiplicand << 1;
                    if (multiplier[ctr] == 1) begin
                        product <= product + multiplicand;
                    end
                    ctr <= ctr + 1;
                end else begin
                    state <= 0;
                    rdy <= 1;
                end
            end
        endcase
    end
end

assign p = product;

endmodule