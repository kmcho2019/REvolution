module multi_16bit (
    input           clk,
    input           rst_n,
    input           start,
    input  [15:0]   ain,
    input  [15:0]   bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0] i;              // shift counter from 0 to 16
    reg [15:0] areg;          // multiplicand register
    reg [15:0] breg;          // multiplier register
    reg [31:0] accum;         // accumulator for partial sums

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i     <= 5'd0;
            areg  <= 16'd0;
            breg  <= 16'd0;
            accum <= 32'd0;
            done  <= 1'b0;
            yout  <= 32'd0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Initialization on start
                    areg  <= ain;
                    breg  <= bin;
                    accum <= 32'd0;
                    i     <= 5'd1;
                    done  <= 1'b0;
                end else if (i <= 5'd16) begin
                    // Shift and accumulate for each bit of multiplier
                    if (breg[0])
                        accum <= accum + {16'd0, areg}; // add multiplicand to accum if LSB of breg is 1
                    else
                        accum <= accum;
                    // Shift areg left by 1 and breg right by 1 for next bit
                    areg <= areg << 1;
                    breg <= breg >> 1;
                    i    <= i + 5'd1;

                    if (i == 5'd16) begin
                        done <= 1'b1; // multiplication done after 16 cycles
                        yout <= accum; // output the product
                    end else begin
                        done <= 1'b0;
                    end
                end else begin
                    // Stay done until start deasserts
                    done <= 1'b1;
                    yout <= accum;
                end
            end else begin
                // When start is low, reset counter and done
                i    <= 5'd0;
                done <= 1'b0;
                yout <= 32'd0;
                // registers retain their values (optional) or can be cleared:
                areg  <= 16'd0;
                breg  <= 16'd0;
                accum <= 32'd0;
            end
        end
    end

endmodule