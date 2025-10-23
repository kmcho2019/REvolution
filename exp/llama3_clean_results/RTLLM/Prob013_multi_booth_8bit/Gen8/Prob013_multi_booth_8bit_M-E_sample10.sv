module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Define the Radix-4 Booth multiplier module
module radix4_booth_multiplier(
    input clk,
    input reset,
    input [3:0] a,
    input [3:0] b,
    output reg [7:0] p
);

reg [7:0] multiplicand;
reg [7:0] multiplier;
reg [3:0] ctr;
reg [7:0] product;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 4) begin
            multiplicand <= multiplicand << 1;
            if (multiplier[ctr] == 1) begin
                product <= product + multiplicand;
            end
            ctr <= ctr + 1;
        end
    end
end

assign p = product;

endmodule

// Define the controller module
reg [15:0] product1;
reg [15:0] product2;
reg rdy1;
reg rdy2;

radix4_booth_multiplier multiplier1(
   .clk(clk),
   .reset(reset),
   .a(a[7:4]),
   .b(b[7:4]),
   .p(product1)
);

radix4_booth_multiplier multiplier2(
   .clk(clk),
   .reset(reset),
   .a(a[3:0]),
   .b(b[3:0]),
   .p(product2)
);

always @(posedge clk) begin
    if (reset) begin
        rdy <= 0;
    end else begin
        if (rdy1 && rdy2) begin
            p <= product1 + product2;
            rdy <= 1;
        end
    end
end

assign rdy1 = (product1!= 0);
assign rdy2 = (product2!= 0);

endmodule