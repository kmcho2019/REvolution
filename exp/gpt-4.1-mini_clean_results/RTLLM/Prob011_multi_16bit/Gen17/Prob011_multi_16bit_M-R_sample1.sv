module multi_16bit (
    input          clk,
    input          rst_n,    // active-low reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg       done
);

    reg [4:0] i;            // shift count 0..17
    reg [15:0] areg;        // multiplicand register
    reg [31:0] breg;        // shifted multiplier register
    reg [31:0] yout_r;      // product accumulator

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i      <= 5'd0;
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
            done   <= 1'b0;
            yout   <= 32'd0;
        end else begin
            // Counter update
            if (!start)
                i <= 5'd0;
            else if (i < 5'd17)
                i <= i + 5'd1;
            else
                i <= 5'd0;

            // Done flag logic
            if (i == 5'd16)
                done <= 1'b1;
            else if (i == 5'd17)
                done <= 1'b0;

            // Shift and accumulate operation
            case (i)
                5'd0: begin
                    // Load inputs
                    areg   <= ain;
                    breg   <= {16'd0, bin};
                    yout_r <= 32'd0;
                end
                5'd1, 5'd2, 5'd3, 5'd4, 5'd5, 5'd6, 5'd7, 5'd8,
                5'd9, 5'd10, 5'd11, 5'd12, 5'd13, 5'd14, 5'd15, 5'd16: begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i - 1));
                    end else begin
                        yout_r <= yout_r;
                    end
                end
                default: begin
                    // Hold registers
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                end
            endcase

            yout <= yout_r;
        end
    end

endmodule