module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         valid
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accum;
    reg [3:0] count; // to count 8 cycles

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 8'd0;
            multiplier   <= 8'd0;
            accum        <= 16'd0;
            count        <= 4'd0;
            product      <= 16'd0;
            valid        <= 1'b0;
        end else begin
            if (count == 4'd0) begin
                // Initialize operands at start
                multiplicand <= A;
                multiplier   <= B;
                accum        <= 16'd0;
                product      <= 16'd0;
                valid        <= 1'b0;
                count        <= count + 1;
            end else if (count <= 4'd8) begin
                // On each cycle: if LSB of multiplier is 1, add multiplicand to accum
                if (multiplier[0])
                    accum <= accum + {8'd0, multiplicand};

                // Shift multiplicand left by 1 for next bit
                multiplicand <= multiplicand << 1;
                // Shift multiplier right by 1 to process next bit
                multiplier <= multiplier >> 1;

                count <= count + 1;

                if (count == 4'd8) begin
                    product <= accum;
                    valid <= 1'b1; // product is valid after 8 iterations
                end
            end else begin
                // Hold output after completion
                product <= accum;
                valid <= 1'b1;
            end
        end
    end

endmodule