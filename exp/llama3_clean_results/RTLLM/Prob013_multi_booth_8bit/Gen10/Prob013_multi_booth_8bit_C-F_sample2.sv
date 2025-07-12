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

// Clock gating to reduce power consumption
reg clk_enable;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
        clk_enable <= 0;
    end else begin
        case (state)
            0: begin
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= 1;
                clk_enable <= 1;
            end
            1: begin
                if (ctr < 16) begin
                    if (clk_enable) begin
                        multiplicand <= multiplicand << 1;
                        if (multiplier[ctr] == 1) begin
                            product <= product + multiplicand;
                        end
                        ctr <= ctr + 1;
                    end
                end else begin
                    state <= 2;
                    clk_enable <= 0;
                end
            end
            2: begin
                p <= product;
                rdy <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule