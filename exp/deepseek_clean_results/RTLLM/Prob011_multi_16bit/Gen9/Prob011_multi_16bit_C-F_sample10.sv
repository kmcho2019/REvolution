module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;            // 4-bit counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register
    reg [15:0] breg_shifted [15:0]; // Pre-computed shifted versions

    // Pre-compute all possible shifted versions
    integer j;
    always @(*) begin
        for (j = 0; j < 16; j = j + 1) begin
            breg_shifted[j] = breg << j;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (i == 4'd0) begin
                    // Load operands at start
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    done <= 1'b0;
                    i <= i + 1;
                end else if (i < 4'd15) begin
                    // Shift-and-add operation
                    if (areg[i-1]) begin
                        yout_r <= yout_r + {16'd0, breg_shifted[i-1]};
                    end
                    i <= i + 1;
                end else if (i == 4'd15) begin
                    // Final iteration
                    if (areg[i-1]) begin
                        yout_r <= yout_r + {16'd0, breg_shifted[i-1]};
                    end
                    done <= 1'b1;
                    i <= i + 1;
                end else begin
                    // Hold after completion
                    done <= 1'b0;
                end
            end else begin
                // Clear when not started
                i <= 4'd0;
                done <= 1'b0;
            end
        end
    end

    // Output assignment
    always @(*) begin
        yout = yout_r;
    end

endmodule