module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg         done
);

    reg [4:0] i;         // shift count (0 to 17)
    reg [15:0] areg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i    <= 5'd0;
            areg <= 16'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else if (!start) begin
            i    <= 5'd0;
            areg <= 16'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            if (i == 5'd0) begin
                // load multiplicand and reset product
                areg <= ain;
                yout <= 32'd0;
                done <= 1'b0;
                i <= i + 1;
            end else if (i <= 5'd16) begin
                // for each bit, add shifted bin if corresponding areg bit is 1
                if (areg[0])
                    yout <= yout + (bin << (i - 1));
                areg <= areg >> 1;
                i <= i + 1;
                if (i == 5'd16)
                    done <= 1'b1;
            end else begin
                // after completion, hold done flag and outputs
                done <= done;
                yout <= yout;
                areg <= areg;
                i <= i;
            end
        end
    end

endmodule