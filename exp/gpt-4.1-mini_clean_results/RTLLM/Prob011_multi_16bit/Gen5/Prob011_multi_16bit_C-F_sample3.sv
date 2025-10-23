module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    reg [4:0]    i;         // shift count: 0 to 17
    reg          done_r;
    reg [15:0]   areg;      // multiplicand register (shift right)
    reg [31:0]   breg;      // multiplier register zero-extended and shifted left
    reg [31:0]   yout_r;    // product accumulator

    // Shift count register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (!start) begin
            i <= 5'd0;
        end else if (i < 5'd17) begin
            i <= i + 5'd1;
        end
    end

    // Done flag update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end
    end

    // Shift and accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else if (!start) begin
            // Clear on start inactive
            areg   <= 16'd0;
            breg   <= 32'd0;
            yout_r <= 32'd0;
        end else begin
            case (i)
                5'd0: begin
                    // Load inputs and clear accumulator at start
                    areg   <= ain;
                    breg   <= {16'd0, bin}; // zero-extend multiplier
                    yout_r <= 32'd0;
                end
                5'd1,5'd2,5'd3,5'd4,5'd5,5'd6,5'd7,5'd8,
                5'd9,5'd10,5'd11,5'd12,5'd13,5'd14,5'd15,5'd16: begin
                    // For each bit, add shifted multiplier if LSB of areg is 1
                    if (areg[0])
                        yout_r <= yout_r + breg;
                    // Shift areg right, breg left for next bit
                    areg <= areg >> 1;
                    breg <= breg << 1;
                end
                default: begin
                    // Hold registers after completion
                    areg   <= areg;
                    breg   <= breg;
                    yout_r <= yout_r;
                end
            endcase
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule