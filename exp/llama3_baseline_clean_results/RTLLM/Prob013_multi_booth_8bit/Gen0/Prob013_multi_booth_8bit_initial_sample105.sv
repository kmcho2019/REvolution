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
    if(reset) begin
        multiplier <= {{8{a[7]}}, a};  // Sign extend and initialize multiplicand
        multiplicand <= {{8{b[7]}}, b};  // Sign extend and initialize multiplier
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if(ctr < 16) begin
            multiplicand <= multiplicand << 1;  // Left shift multiplicand
            if(multiplier[ctr] == 1'b1) begin
                p <= p + multiplicand;  // Accumulate multiplicand if current bit is 1
            end
            ctr <= ctr + 1;
        end else begin
            rdy <= 1'b1;  // Set ready signal to 1 once counter reaches 16
        end
    end
end

endmodule