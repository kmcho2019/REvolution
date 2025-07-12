module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         valid
);

    reg [7:0] multiplier;
    reg [15:0] multiplicand_shifted;
    reg [3:0] bit_count;
    reg [15:0] accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product <= 16'b0;
            valid <= 1'b0;
            multiplier <= 8'b0;
            multiplicand_shifted <= 16'b0;
            bit_count <= 4'b0;
            accumulator <= 16'b0;
        end else begin
            if (bit_count == 0) begin
                // Load inputs at start of multiplication
                multiplier <= B;
                multiplicand_shifted <= {8'b0, A}; // Zero-extend A to 16 bits
                accumulator <= 16'b0;
                valid <= 1'b0;
                bit_count <= 4'd8;
            end else begin
                // Shift-and-add iteration
                if (multiplier[0])
                    accumulator <= accumulator + multiplicand_shifted;
                else
                    accumulator <= accumulator;

                multiplicand_shifted <= multiplicand_shifted << 1;
                multiplier <= multiplier >> 1;
                bit_count <= bit_count - 1;

                if (bit_count == 1) begin
                    product <= accumulator + (multiplier[0] ? multiplicand_shifted : 16'b0);
                    valid <= 1'b1;
                end else begin
                    valid <= 1'b0;
                end
            end
        end
    end

endmodule