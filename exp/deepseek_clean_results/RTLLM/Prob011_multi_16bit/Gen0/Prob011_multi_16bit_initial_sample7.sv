module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [4:0] i;            // Shift counter (0-16)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register
    reg done_r;             // Done flag register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            i <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i == 5'd0) begin
                    // Load operands at start
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    done_r <= 1'b0;
                    i <= i + 1;
                end else if (i < 5'd17) begin
                    // Shift-and-add operation
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                    
                    // Set done flag when complete
                    if (i == 5'd16) begin
                        done_r <= 1'b1;
                    end
                end else begin
                    // Clear done flag after completion
                    done_r <= 1'b0;
                    i <= 5'd0;
                end
            end else begin
                // Clear when not started
                i <= 5'd0;
                done_r <= 1'b0;
            end
        end
    end

    // Output assignments
    always @(*) begin
        yout = yout_r;
        done = done_r;
    end

endmodule