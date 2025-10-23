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
reg [15:0] product;
reg state;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        state <= 0;
        rdy <= 0;
    end else begin
        case (state)
            0: begin // Idle state
                if (a!== 0 || b!== 0) begin
                    multiplicand <= {{8{b[7]}}, b};
                    multiplier <= {{8{a[7]}}, a};
                    state <= 1;
                end
            end
            1: begin // Multiplication state
                if (multiplier!== 0) begin
                    if (multiplier[0]) begin
                        product <= product + multiplicand;
                    end
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                end else begin
                    p <= product;
                    rdy <= 1;
                    state <= 0;
                end
            end
            default: state <= 0;
        endcase
    end
end

endmodule