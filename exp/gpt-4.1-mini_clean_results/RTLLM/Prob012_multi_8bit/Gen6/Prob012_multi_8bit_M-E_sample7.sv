module multi_8bit (
    input        clk,
    input        rst_n,
    input        start,
    input  [7:0] A,
    input  [7:0] B,
    output reg [15:0] product,
    output reg       done
);

    reg [7:0]  multiplicand;
    reg [7:0]  multiplier;
    reg [15:0] acc;          // Accumulator for product
    reg [3:0]  count;        // Counts up to 8 cycles
    reg        busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            acc          <= 16'b0;
            multiplicand <= 8'b0;
            multiplier   <= 8'b0;
            count        <= 4'b0;
            product      <= 16'b0;
            done         <= 1'b0;
            busy         <= 1'b0;
        end else if (start && !busy) begin
            // Initialize registers for multiplication
            acc          <= 16'b0;
            multiplicand <= A;
            multiplier   <= B;
            count        <= 4'd8;
            done         <= 1'b0;
            busy         <= 1'b1;
        end else if (busy) begin
            if (multiplier[0]) begin
                acc <= acc + {8'b0, multiplicand};
            end
            multiplicand <= multiplicand << 1;
            multiplier   <= multiplier >> 1;
            count        <= count - 1;

            if (count == 1) begin
                product <= acc + ({8'b0, multiplicand} & {16{multiplier[0]}});
                done <= 1'b1;
                busy <= 1'b0;
            end
        end else begin
            done <= 1'b0; // clear done after one clock
        end
    end

endmodule