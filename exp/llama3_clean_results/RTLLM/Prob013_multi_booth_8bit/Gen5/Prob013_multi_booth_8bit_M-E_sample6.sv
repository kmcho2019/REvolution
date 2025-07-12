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
reg [15:0] product;
reg [3:0] stage;
reg [15:0] temp_product;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        stage <= 0;
        rdy <= 0;
    end else begin
        case (stage)
            0: begin // Initialization
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                stage <= 1;
            end
            1: begin // Booth Encoding
                if (multiplier[0] == 1) begin
                    if (multiplier[1] == 1) begin
                        // Add 2*multiplicand
                        temp_product <= multiplicand << 1;
                    end else begin
                        // Add multiplicand
                        temp_product <= multiplicand;
                    end
                end else if (multiplier[1] == 1) begin
                    // Subtract multiplicand
                    temp_product <= ~multiplicand + 1;
                end else begin
                    // Do nothing
                    temp_product <= 0;
                end
                stage <= 2;
            end
            2: begin // Multiplication
                product <= product + temp_product;
                multiplier <= multiplier >> 1;
                if (multiplier == 0) begin
                    stage <= 3;
                end else begin
                    stage <= 1;
                end
            end
            3: begin // Finalization
                p <= product;
                rdy <= 1;
                stage <= 0;
            end
            default: begin
                stage <= 0;
            end
        endcase
    end
end

endmodule