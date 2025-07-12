module multi_16bit (
    input          clk,
    input          rst_n,   // active low synchronous reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;
    reg [15:0] areg;
    reg [31:0] breg;
    reg [31:0] acc;

    always @(posedge clk) begin
        if (!rst_n) begin
            i    <= 5'd0;
            areg <= 16'd0;
            breg <= 32'd0;
            acc  <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    areg <= ain;
                    breg <= {16'd0, bin}; // extend multiplier to 32 bits
                    acc  <= 32'd0;
                    done <= 1'b0;
                    i    <= 5'd1;
                end else if (i <= 5'd16) begin
                    // If LSB of areg is 1, accumulate shifted breg
                    if (areg[0])
                        acc <= acc + breg;
                    else
                        acc <= acc;
                    // Shift areg right and breg left
                    areg <= areg >> 1;
                    breg <= breg << 1;
                    i    <= i + 5'd1;
                    done <= (i == 5'd16);
                end else begin
                    // Multiplication done, hold outputs
                    i    <= i;
                    acc  <= acc;
                    areg <= areg;
                    breg <= breg;
                    done <= 1'b1;
                end
            end else begin
                // start low, reset counter and done flag
                i    <= 5'd0;
                done <= 1'b0;
                // Hold other registers
                areg <= areg;
                breg <= breg;
                acc  <= acc;
            end
            yout <= acc;
        end
    end

endmodule