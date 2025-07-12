module multi_booth_8bit(
    input clk, 
    input reset, 
    input [7:0] a, 
    input [7:0] b, 
    output reg [15:0] p, 
    output reg rdy
);

reg [4:0] ctr;
reg [15:0] multiplicand;
reg [15:0] product;
reg [1:0] booth_encode;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        product <= 0;
        multiplicand <= {{8{b[7]}}, b};
        p <= 0;
        rdy <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 16) begin
            // Radix-4 Booth encoding
            booth_encode <= {a[ctr+1], a[ctr]};
            case (booth_encode)
                2'b00: product <= product; // do nothing
                2'b01: product <= product + multiplicand; // add
                2'b10: product <= product - multiplicand; // subtract
                2'b11: product <= product + (multiplicand << 1); // add shifted
            endcase
            multiplicand <= multiplicand << 1; // shift multiplicand
            ctr <= ctr + 1;
        end else begin
            p <= product;
            rdy <= 1;
        end
    end
end

endmodule