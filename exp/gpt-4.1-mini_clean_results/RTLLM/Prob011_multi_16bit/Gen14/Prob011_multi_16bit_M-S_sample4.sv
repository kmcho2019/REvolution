module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg      done
);

    reg [4:0]    i;
    reg [15:0]   areg;
    reg [31:0]   breg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i     <= 5'd0;
            areg  <= 16'd0;
            breg  <= 32'd0;
            yout  <= 32'd0;
            done  <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load operands at start
                    areg <= ain;
                    breg <= {16'd0, bin};
                    yout <= 32'd0;
                    done <= 1'b0;
                    i    <= 5'd1;
                end else if (i <= 5'd16) begin
                    // If LSB of areg is 1, accumulate breg to yout
                    if (areg[0])
                        yout <= yout + breg;
                    else
                        yout <= yout;
                    // Shift areg right and breg left
                    areg <= areg >> 1;
                    breg <= breg << 1;

                    if (i == 5'd16)
                        done <= 1'b1;
                    i <= i + 5'd1;
                end else if (i == 5'd17) begin
                    // Hold done for one cycle then reset
                    done <= 1'b0;
                    i <= 5'd0;
                end
            end else begin
                // When not started, reset counter and done flag
                i    <= 5'd0;
                done <= 1'b0;
            end
        end
    end

endmodule