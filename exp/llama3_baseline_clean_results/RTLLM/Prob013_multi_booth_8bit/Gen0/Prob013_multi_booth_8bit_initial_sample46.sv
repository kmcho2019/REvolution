module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplier;
reg [15:0] multiplicand;
reg [4:0] ctr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        ctr <= 0;
        p <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            multiplicand <= multiplicand << 1;
            case ({multiplier[ctr+1], multiplier[ctr]})
                2'b01: p <= p + multiplicand; // + multiplicand
                2'b10: p <= p - multiplicand; // - multiplicand
                default: p <= p; // no operation
            endcase
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
        end
    end
end

endmodule