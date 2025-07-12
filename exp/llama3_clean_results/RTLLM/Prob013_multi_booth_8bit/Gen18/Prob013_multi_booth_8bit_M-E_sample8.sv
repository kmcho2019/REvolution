module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Multiplier Encoding Unit (MEU)
reg [7:0] booth_codes;
always @(*) begin
    booth_codes = 0;
    for (int i = 0; i < 8; i++) begin
        if (a[i]) begin
            booth_codes[i*2] = 1;
            if (i < 7 && a[i+1]) begin
                booth_codes[i*2+1] = 1;
            end
        end
    end
end

// Parallel Partial Product Generation Unit (PPPGU)
reg [15:0] partial_products [7:0];
always @(*) begin
    for (int i = 0; i < 8; i++) begin
        if (booth_codes[i*2]) begin
            partial_products[i] = b << i;
        end else if (booth_codes[i*2+1]) begin
            partial_products[i] = b << (i+1);
        end else begin
            partial_products[i] = 0;
        end
    end
end

// Sequential Accumulation Unit (SAU)
reg [15:0] product;
reg [2:0] counter;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        product <= 0;
        counter <= 0;
        rdy <= 0;
    end else begin
        if (counter < 8) begin
            product <= product + partial_products[counter];
            counter <= counter + 1;
        end else begin
            p <= product;
            rdy <= 1;
        end
    end
end

endmodule