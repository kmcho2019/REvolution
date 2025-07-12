module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0]  count;    // shift count from 0 to 16
    reg [15:0] multiplicand;
    reg [31:0] multiplier;
    reg [31:0] accumulator;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 5'd0;
            multiplicand <= 16'd0;
            multiplier   <= 32'd0;
            accumulator  <= 32'd0;
            done         <= 1'b0;
            yout         <= 32'd0;
        end else if (!start) begin
            // Idle/reset on start deasserted
            count        <= 5'd0;
            multiplicand <= 16'd0;
            multiplier   <= 32'd0;
            accumulator  <= 32'd0;
            done         <= 1'b0;
            yout         <= 32'd0;
        end else begin
            if (count == 5'd0) begin
                // Load inputs and clear accumulator at start of operation
                multiplicand <= ain;
                multiplier   <= {16'd0, bin};
                accumulator  <= 32'd0;
                done         <= 1'b0;
                count        <= count + 5'd1;
            end else if (count <= 5'd16) begin
                // For each bit position
                if (multiplicand[0])
                    accumulator <= accumulator + multiplier;
                else
                    accumulator <= accumulator;
                
                multiplicand <= multiplicand >> 1;
                multiplier   <= multiplier << 1;

                if (count == 5'd16) begin
                    done  <= 1'b1;
                    yout  <= accumulator;
                    count <= count + 5'd1; // increment to stop further processing
                end else begin
                    count <= count + 5'd1;
                end
            end else begin
                // Hold done and output stable after completion
                done <= done;
                yout <= yout;
            end
        end
    end

endmodule