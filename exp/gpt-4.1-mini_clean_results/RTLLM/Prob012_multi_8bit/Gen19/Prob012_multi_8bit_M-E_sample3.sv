module multi_8bit (
    input         clk,
    input         rst_n,
    input         start,
    input  [7:0]  A,
    input  [7:0]  B,
    output reg [15:0] product,
    output reg    done
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] acc;
    reg [3:0] count;
    reg busy;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 8'b0;
            multiplier   <= 8'b0;
            acc          <= 16'b0;
            count        <= 4'd0;
            product      <= 16'b0;
            done         <= 1'b0;
            busy         <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initialize registers for multiplication
                multiplicand <= A;
                multiplier   <= B;
                acc          <= 16'b0;
                count        <= 4'd0;
                done         <= 1'b0;
                busy         <= 1'b1;
            end else if (busy) begin
                // Perform one step of shift-and-add multiplication
                if (multiplier[0])
                    acc <= acc + {8'b0, multiplicand};
                multiplicand <= multiplicand << 1;
                multiplier   <= multiplier >> 1;
                count <= count + 1'b1;

                if (count == 4'd7) begin
                    product <= acc;
                    done <= 1'b1;
                    busy <= 1'b0;
                end
            end else begin
                done <= 1'b0; // Ready for next start
            end
        end
    end

endmodule