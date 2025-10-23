module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Segmentation Unit
wire [1:0] segment1 = a[7:6];
wire [1:0] segment2 = a[5:4];
wire [1:0] segment3 = a[3:2];
wire [1:0] segment4 = a[1:0];

// Parallel Processing Units
reg [15:0] partial_product1;
reg [15:0] partial_product2;
reg [15:0] partial_product3;
reg [15:0] partial_product4;

always @(posedge clk) begin
    if (reset) begin
        partial_product1 <= 0;
        partial_product2 <= 0;
        partial_product3 <= 0;
        partial_product4 <= 0;
    end else begin
        // Calculate partial products based on Radix-4 encoding
        case (segment1)
            2'b00: partial_product1 <= {8{1'b0}} << 14;
            2'b01: partial_product1 <= {8{1'b0}} << 13;
            2'b10: partial_product1 <= -({8{1'b0}} << 13);
            2'b11: partial_product1 <= -({8{1'b0}} << 14);
        endcase
        
        case (segment2)
            2'b00: partial_product2 <= {8{1'b0}} << 12;
            2'b01: partial_product2 <= {8{1'b0}} << 11;
            2'b10: partial_product2 <= -({8{1'b0}} << 11);
            2'b11: partial_product2 <= -({8{1'b0}} << 12);
        endcase
        
        case (segment3)
            2'b00: partial_product3 <= {8{1'b0}} << 10;
            2'b01: partial_product3 <= {8{1'b0}} << 9;
            2'b10: partial_product3 <= -({8{1'b0}} << 9);
            2'b11: partial_product3 <= -({8{1'b0}} << 10);
        endcase
        
        case (segment4)
            2'b00: partial_product4 <= {8{1'b0}} << 8;
            2'b01: partial_product4 <= {8{1'b0}} << 7;
            2'b10: partial_product4 <= -({8{1'b0}} << 7);
            2'b11: partial_product4 <= -({8{1'b0}} << 8);
        endcase
    end
end

// Serial Combiner
reg [15:0] product;
reg [1:0] state;
always @(posedge clk) begin
    if (reset) begin
        product <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                product <= partial_product1 * b;
                state <= 1;
            end
            1: begin
                product <= product + partial_product2 * b;
                state <= 2;
            end
            2: begin
                product <= product + partial_product3 * b;
                state <= 3;
            end
            3: begin
                product <= product + partial_product4 * b;
                state <= 4;
            end
            4: begin
                p <= product;
                rdy <= 1;
                state <= 0;
            end
        endcase
    end
end

endmodule