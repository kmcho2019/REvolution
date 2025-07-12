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
reg [15:0] accumulated_product;
reg [3:0] stage;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        p <= 0;
        ctr <= 0;
        rdy <= 0;
        stage <= 0;
    end else begin
        case (stage)
            0: begin // Booth encoding stage
                if (ctr < 16) begin
                    partial_product <= (multiplier[ctr] == 1) ? multiplicand : 0;
                    multiplicand <= multiplicand << 1;
                    ctr <= ctr + 1;
                    stage <= 1;
                end else begin
                    stage <= 4;
                end
            end
            1: begin // Partial product generation stage
                accumulated_product <= accumulated_product + partial_product;
                stage <= 2;
            end
            2: begin // Accumulation stage
                if (ctr < 16) begin
                    stage <= 0;
                end else begin
                    stage <= 3;
                end
            end
            3: begin // Output stage
                p <= accumulated_product;
                rdy <= 1;
                stage <= 4;
            end
            4: begin // Reset stage
                stage <= 0;
            end
        endcase
    end
end

endmodule