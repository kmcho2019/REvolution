module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplier;    // holds multiplicand as per spec: multiplier <= {{8{a[7]}}, a}
    reg [15:0] multiplicand;  // holds multiplier as per spec: multiplicand <= {{8{b[7]}}, b}
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplier   <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            p            <= 16'b0;
            ctr          <= 5'b0;
            rdy          <= 1'b0;
        end else begin
            if (ctr < 16) begin
                if (multiplier[ctr] == 1'b1) begin
                    p <= p + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;
            end
        end
    end

endmodule