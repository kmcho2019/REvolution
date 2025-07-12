module multi_8bit (
    input           clk,
    input           reset_n,
    input           start,
    input  [7:0]    A,
    input  [7:0]    B,
    output reg [15:0] product,
    output reg      done
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accum;
    reg [3:0] count;
    reg busy;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            product    <= 16'd0;
            done       <= 1'b0;
            multiplicand <= 8'd0;
            multiplier <= 8'd0;
            accum      <= 16'd0;
            count      <= 4'd0;
            busy       <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Load inputs and initialize
                multiplicand <= A;
                multiplier <= B;
                accum <= 16'd0;
                count <= 4'd0;
                done <= 1'b0;
                busy <= 1'b1;
            end else if (busy) begin
                if (multiplier[0]) begin
                    accum <= accum + {8'd0, multiplicand};
                end
                multiplier <= multiplier >> 1;
                multiplicand <= multiplicand << 1;
                count <= count + 1;

                if (count == 4'd7) begin
                    product <= accum;
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                done <= 1'b0;  // Clear done after acknowledged
            end
        end
    end

endmodule