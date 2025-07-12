module multi_8bit (
    input           clk,
    input           rst_n,
    input  [7:0]    A,
    input  [7:0]    B,
    output reg [15:0] product,
    output reg      ready
);

    reg [7:0] multiplier;
    reg [15:0] multiplicand;
    reg [3:0] count;
    reg [15:0] prod_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplier  <= 8'd0;
            multiplicand <= 16'd0;
            prod_reg    <= 16'd0;
            count       <= 4'd0;
            product     <= 16'd0;
            ready       <= 1'b0;
        end else begin
            if (count == 4'd0) begin
                // Load inputs and clear product on start
                multiplier  <= B;
                multiplicand <= {8'd0, A};
                prod_reg    <= 16'd0;
                ready       <= 1'b0;
                count       <= 4'd8;
            end else if (count > 0) begin
                if (multiplier[0]) begin
                    prod_reg <= prod_reg + multiplicand;
                end
                multiplicand <= multiplicand << 1;
                multiplier <= multiplier >> 1;
                count <= count - 1;
                if (count == 1) begin
                    product <= prod_reg + (multiplier[0] ? multiplicand : 16'd0);
                    ready <= 1'b1;
                end
            end else begin
                // Hold output stable when ready
                ready <= 1'b1;
            end
        end
    end

endmodule