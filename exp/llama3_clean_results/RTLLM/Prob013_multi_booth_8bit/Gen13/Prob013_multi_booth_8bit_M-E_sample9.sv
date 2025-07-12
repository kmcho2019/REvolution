module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Stage 1: Booth encoding and multiplicand preparation
reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [7:0] booth_encoded;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        booth_encoded <= 0;
    end else begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        booth_encoded <= {a[7] ? ~a[6] : a[6], a[5:0]};
    end
end

// Stage 2: Partial product generation
reg [15:0] partial_product;

always @(posedge clk) begin
    if (reset) begin
        partial_product <= 0;
    end else begin
        partial_product <= multiplicand * booth_encoded;
    end
end

// Stage 3: Partial product accumulation
reg [15:0] accumulated_product;
reg [4:0] ctr;

always @(posedge clk) begin
    if (reset) begin
        accumulated_product <= 0;
        ctr <= 0;
    end else begin
        if (ctr < 16) begin
            accumulated_product <= accumulated_product + partial_product;
            ctr <= ctr + 1;
        end
    end
end

// Stage 4: Final product formation
always @(posedge clk) begin
    if (reset) begin
        p <= 0;
        rdy <= 0;
    end else begin
        if (ctr == 16) begin
            p <= accumulated_product;
            rdy <= 1;
        end
    end
end

endmodule