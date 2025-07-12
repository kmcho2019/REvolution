module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [15:0] areg, breg;
reg [31:0] yout_r;
reg [4:0] i;  // Counter for 16 bits (0-16)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
        i <= 5'b0;
        done <= 1'b0;
    end else begin
        if (start) begin
            if (i == 5'd0) begin
                // Load input values at start
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                i <= i + 1;
                done <= 1'b0;
            end else if (i <= 5'd16) begin
                // Shift-and-add operation
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
                // Set done flag when last bit processed
                done <= (i == 5'd16) ? 1'b1 : 1'b0;
            end else begin
                // Hold after completion
                done <= 1'b0;
            end
        end else begin
            // Reset counter when not started
            i <= 5'b0;
            done <= 1'b0;
        end

        // Register output when done
        if (i == 5'd16) begin
            yout <= yout_r;
        end
    end
end

endmodule