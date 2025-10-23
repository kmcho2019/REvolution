module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0] i;            // shift count register (0 to 17)
    reg [15:0] areg;        // multiplicand register
    reg [15:0] breg;        // multiplier register
    reg [31:0] yout_r;      // product accumulator register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
            done   <= 1'b0;
            yout   <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load multiplicand and multiplier on start cycle
                    areg   <= ain;
                    breg   <= bin;
                    yout_r <= 32'd0;
                    done   <= 1'b0;
                    i      <= i + 1'b1;
                end else if (i < 5'd17) begin
                    // For bits 0 to 15 (i-1), if bit of areg is 1, accumulate shifted breg
                    if (areg[i - 1]) begin
                        yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
                    end
                    i <= i + 1'b1;
                    if (i == 5'd16) begin
                        done <= 1'b1;  // multiplication done after 16 cycles
                    end else begin
                        done <= 1'b0;
                    end
                end else if (i == 5'd17) begin
                    // Clear done flag after cycle 17
                    done <= 1'b0;
                    i <= 5'd0;
                end
            end else begin
                // When start is low, reset counter and done
                i    <= 5'd0;
                done <= 1'b0;
            end
            yout <= yout_r;
        end
    end

endmodule