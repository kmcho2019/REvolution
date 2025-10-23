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
reg [4:0] ctr;
reg [15:0] partial_product;
reg [15:0] product;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        p <= 0;
        ctr <= 0;
        rdy <= 0;
        partial_product <= 0;
        product <= 0;
    end else begin
        case (ctr)
            0: begin
                // Sign extension
                multiplicand <= { {8{b[7]}}, b };
                multiplier <= { {8{a[7]}}, a };
                ctr <= ctr + 1;
            end
            1: begin
                // Booth encoding
                if (multiplier[ctr-1] == 1) begin
                    partial_product <= multiplicand;
                end else begin
                    partial_product <= 0;
                end
                ctr <= ctr + 1;
            end
            2: begin
                // Multiplication
                product <= product + partial_product;
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
            end
            3: begin
                // Accumulation
                if (ctr == 15) begin
                    p <= product;
                    rdy <= 1;
                end else begin
                    ctr <= ctr + 1;
                end
            end
            default: begin
                // Idle state
                rdy <= 1;
            end
        endcase
    end
end

endmodule