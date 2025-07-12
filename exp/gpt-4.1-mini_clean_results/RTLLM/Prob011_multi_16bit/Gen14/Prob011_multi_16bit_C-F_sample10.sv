module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // Shift count: 0 = idle, 1..16 = active multiplication, 17 = done
    reg [4:0]       count;
    reg [31:0]      product;       // [31:16] accumulator, [15:0] multiplier bits
    reg [15:0]      multiplicand;
    reg             done_r;

    // Sequential logic block: count, product, multiplicand, done_r updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count        <= 5'd0;
            product      <= 32'd0;
            multiplicand <= 16'd0;
            done_r       <= 1'b0;
        end else begin
            case (count)
                5'd0: begin // idle: wait for start
                    done_r <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                        product     <= {16'd0, bin}; // load multiplier
                        count       <= 5'd1;
                    end
                end

                5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8,
                5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15, 5'd16: begin
                    // Shift and accumulate step:
                    // If LSB multiplier bit is 1, add multiplicand shifted to upper half
                    if (product[0]) 
                        product <= (product >> 1) + ({multiplicand,16'd0} >> 1);
                    else
                        product <= product >> 1;
                    count <= count + 5'd1;
                end

                5'd17: begin
                    done_r <= 1'b1;     // multiplication complete
                    if (start) begin
                        // Restart multiplication immediately on new start
                        multiplicand <= ain;
                        product     <= {16'd0, bin};
                        count       <= 5'd1;
                        done_r      <= 1'b0;
                    end else begin
                        // Otherwise remain done until start or reset
                        count <= 5'd17;
                    end
                end

                default: begin
                    count  <= 5'd0;
                    done_r <= 1'b0;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule