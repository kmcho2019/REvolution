module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg        done
);

    reg [4:0] i;              // shift count, 0 to 17 (max 17 as per problem)
    reg [15:0] areg;          // multiplicand register
    reg [15:0] breg;          // multiplier register
    reg [31:0] yout_r;        // product register

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else begin
            if (!start) begin
                i <= 5'd0;
            end else if (start && i < 5'd17) begin
                i <= i + 5'd1;
            end
        end
    end

    // done flag update according to i count
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done <= 1'b0;
        end else begin
            if (i == 5'd16)
                done <= 1'b1;
            else if (i == 5'd17)
                done <= 1'b0;
            // else keep done as is
        end
    end

    // Shift and accumulate operation and register loading
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 16'd0;
            yout_r <= 32'd0;
        end else begin
            if (start) begin
                case (i)
                    5'd0: begin
                        // Load multiplicand and multiplier registers at count 0
                        areg   <= ain;
                        breg   <= bin;
                        yout_r <= 32'd0;
                    end
                    5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7,
                    5'd8, 5'd9, 5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16: begin
                        // For each bit position i-1 in areg, if bit set add (breg << (i-1))
                        if (areg[i-1])
                            yout_r <= yout_r + ( {16'd0, breg} << (i - 1) );
                        else
                            yout_r <= yout_r;
                    end
                    default: begin
                        yout_r <= yout_r;
                    end
                endcase
            end else begin
                // If not start, reset product and inputs to zero
                areg   <= 16'd0;
                breg   <= 16'd0;
                yout_r <= 32'd0;
            end
        end
    end

    // Assign registered product to output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'd0;
        end else begin
            yout <= yout_r;
        end
    end

endmodule