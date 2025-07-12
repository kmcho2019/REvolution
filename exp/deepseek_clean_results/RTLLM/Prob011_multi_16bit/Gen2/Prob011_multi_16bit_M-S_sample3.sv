module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;            // Shift counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
            done <= 1'b0;
        end
        else begin
            // Default assignments
            done <= 1'b0;
            
            if (start) begin
                if (i == 4'd0) begin
                    // Load operands at start
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'd0;
                    i <= i + 1;
                end
                else if (i < 4'd16) begin
                    // Check current bit and accumulate if set
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                end
                else if (i == 4'd16) begin
                    // Multiplication complete
                    done <= 1'b1;
                end
            end
            else begin
                // Clear when not started
                i <= 4'd0;
                yout_r <= 32'd0;
            end
        end
    end

    // Output assignment
    always @(*) begin
        yout = yout_r;
    end

endmodule