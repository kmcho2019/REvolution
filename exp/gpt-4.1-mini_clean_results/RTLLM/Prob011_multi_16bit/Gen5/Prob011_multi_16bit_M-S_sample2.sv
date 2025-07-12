module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0]  yout,
    output reg         done
);

    reg [4:0]    i;          // shift count: 0 to 16
    reg [15:0]   areg;
    reg [31:0]   breg;
    reg [31:0]   acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i    <= 5'd0;
            areg <= 16'd0;
            breg <= 32'd0;
            acc  <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else if (start) begin
            if (i == 5'd0) begin
                // Initialize registers at start
                areg <= ain;
                breg <= {16'd0, bin};
                acc  <= 32'd0;
                yout <= 32'd0;
                done <= 1'b0;
                i    <= 5'd1;
            end else if (i <= 5'd16) begin
                // Accumulate if LSB of areg is 1
                if (areg[0])
                    acc <= acc + breg;
                else
                    acc <= acc;

                // Shift multiplicand right and multiplier left
                areg <= areg >> 1;
                breg <= breg << 1;

                if (i == 5'd16) begin
                    yout <= acc + (areg[0] ? breg : 32'd0); // last cycle accumulation
                    done <= 1'b1;
                    i    <= 5'd0; // ready for next start
                end else begin
                    i <= i + 5'd1;
                    yout <= 32'd0;
                    done <= 1'b0;
                end
            end
        end else begin
            // Reset if not started
            i    <= 5'd0;
            areg <= 16'd0;
            breg <= 32'd0;
            acc  <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end
    end

endmodule