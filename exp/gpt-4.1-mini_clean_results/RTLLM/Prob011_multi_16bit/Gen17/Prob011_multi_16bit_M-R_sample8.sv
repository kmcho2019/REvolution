module multi_16bit (
    input          clk,
    input          rst_n,    // active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0]  i;         // shift count 0..17
    reg [15:0] areg;      // multiplicand register (shifted right)
    reg [31:0] breg;      // multiplier register shifted left for accumulation
    reg [31:0] yout_r;    // accumulated product register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
            yout   <= 32'd0;
            done   <= 1'b0;
        end else begin
            // Shift count update logic
            if (!start) begin
                i <= 5'd0;
                done <= 1'b0;
            end else if (i < 5'd17) begin
                i <= i + 5'd1;
            end else begin
                i <= 5'd0;
                done <= 1'b0;
            end

            // Control actions based on i value
            case (i)
                5'd0: begin
                    // Load multiplicand and multiplier on start
                    areg   <= ain;
                    breg   <= {16'd0, bin};
                    yout_r <= 32'd0;
                    done   <= 1'b0;
                end
                5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7,
                5'd8, 5'd9, 5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16: begin
                    // If LSB of areg is 1, add shifted breg to product
                    if (areg[0])
                        yout_r <= yout_r + breg;
                    else
                        yout_r <= yout_r;

                    // Shift areg right, breg left by 1
                    areg <= areg >> 1;
                    breg <= breg << 1;

                    done <= 1'b0;
                end
                5'd17: begin
                    // Multiplication complete, output result and set done
                    yout <= yout_r;
                    done <= 1'b1;
                end
                default: begin
                    // Hold registers stable
                    areg <= areg;
                    breg <= breg;
                    yout_r <= yout_r;
                    yout <= yout;
                    done <= done;
                end
            endcase
        end
    end

endmodule