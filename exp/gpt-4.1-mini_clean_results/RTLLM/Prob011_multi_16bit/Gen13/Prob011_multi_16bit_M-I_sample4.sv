module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;             // shift count 0..17 per spec
    reg [15:0] areg;         // multiplicand register
    reg [15:0] breg;         // multiplier register (shifted right each cycle)
    reg [31:0] product;      // accumulating product

    // Shift count update and done flag logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i    <= 5'd0;
            done <= 1'b0;
        end else begin
            if (!start)
                i <= 5'd0;
            else if (i < 5'd17)
                i <= i + 5'd1;

            // done flag update per spec
            if (i == 5'd16)
                done <= 1'b1;
            else if (i == 5'd17)
                done <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg    <= 16'd0;
            product <= 32'd0;
            yout    <= 32'd0;
        end else begin
            if (start) begin
                case (i)
                    5'd0: begin
                        // Load multiplicand and multiplier
                        areg    <= ain;
                        breg    <= bin;
                        product <= 32'd0;
                        yout    <= 32'd0;
                    end
                    5'd1,5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd8,
                    5'd9,5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16: begin
                        // If LSB of breg is 1, add (areg shifted by i-1) to product
                        if (breg[0])
                            product <= product + ({16'd0, areg} << (i - 1));
                        else
                            product <= product;

                        // Shift multiplier right by 1 for next bit
                        breg <= breg >> 1;

                        // On last count, assign yout
                        if (i == 5'd16)
                            yout <= product + ((breg[0]) ? ({16'd0, areg} << (i - 1)) : 32'd0);
                    end
                    default: begin
                        // Hold registers
                        areg    <= areg;
                        breg    <= breg;
                        product <= product;
                        yout    <= yout;
                    end
                endcase
            end else begin
                // When start is low, reset registers and output
                areg    <= 16'd0;
                breg    <= 16'd0;
                product <= 32'd0;
                yout    <= 32'd0;
            end
        end
    end

endmodule