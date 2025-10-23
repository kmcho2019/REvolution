module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product
);

    // Internal registers
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] acc;      // Accumulator to hold partial sums
    reg [3:0]  count;    // Counts processed bits (0 to 8)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 8'b0;
            multiplier   <= 8'b0;
            acc          <= 16'b0;
            count        <= 4'b0;
            product      <= 16'b0;
        end else begin
            if (count == 0) begin
                // Load inputs at start of multiplication
                multiplicand <= A;
                multiplier   <= B;
                acc          <= 16'b0;
                count        <= 4'd1; // start counting from 1
                product      <= 16'b0;
            end else if (count <= 8) begin
                // Check LSB of multiplier
                if (multiplier[0]) begin
                    acc <= acc + (multiplicand << (count - 1));
                end
                // Shift multiplier right by 1 to process next bit next cycle
                multiplier <= multiplier >> 1;
                count <= count + 1;
            end else begin
                // Multiplication done, output final product
                product <= acc;
                count <= 0; // ready for next multiplication
            end
        end
    end

endmodule