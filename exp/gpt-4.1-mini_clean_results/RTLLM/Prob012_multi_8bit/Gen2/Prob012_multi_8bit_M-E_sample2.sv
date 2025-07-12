module multi_8bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [7:0]  A,
    input  wire [7:0]  B,
    output reg  [15:0] product,
    output reg         done
);

    reg [15:0] product_reg;
    reg [7:0]  multiplicand;
    reg [7:0]  multiplier;
    reg [3:0]  bit_index;
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            product_reg   <= 16'b0;
            multiplicand  <= 8'b0;
            multiplier    <= 8'b0;
            bit_index     <= 4'd0;
            done          <= 1'b0;
            busy          <= 1'b0;
            product       <= 16'b0;
        end else if (start && !busy) begin
            // Initialize registers to start multiplication
            product_reg  <= 16'b0;
            multiplicand <= A;
            multiplier   <= B;
            bit_index    <= 4'd0;
            busy         <= 1'b1;
            done         <= 1'b0;
        end else if (busy) begin
            // Check current bit of multiplier
            if (multiplier[0]) begin
                product_reg <= product_reg + (multiplicand << bit_index);
            end
            bit_index  <= bit_index + 1;
            multiplier <= multiplier >> 1;
            if (bit_index == 4'd7) begin
                // Finished all bits
                busy    <= 1'b0;
                done    <= 1'b1;
                product <= product_reg;
            end
        end else begin
            done <= 1'b0;
        end
    end

endmodule