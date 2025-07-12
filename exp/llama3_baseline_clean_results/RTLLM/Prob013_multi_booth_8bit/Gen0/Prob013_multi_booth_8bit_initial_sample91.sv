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

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else begin
        if (ctr < 16) begin
            case ({multiplier[ctr], multiplier[ctr+1]})
                2'b00: begin
                    multiplicand <= multiplicand << 1;
                    p <= p;
                end
                2'b01: begin
                    multiplicand <= multiplicand << 1;
                    p <= p + multiplicand;
                end
                2'b10: begin
                    multiplicand <= multiplicand << 1;
                    p <= p - multiplicand;
                end
                2'b11: begin
                    multiplicand <= multiplicand << 1;
                    p <= p;
                end
            endcase
            ctr <= ctr + 1;
        end else begin
            rdy <= 1;
        end
    end
end

endmodule