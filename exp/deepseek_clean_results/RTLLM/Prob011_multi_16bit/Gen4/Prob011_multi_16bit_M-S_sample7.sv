module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg, breg;
    reg [31:0] yout_r;
    reg [3:0] i; // 4 bits sufficient for 0-15 cycles

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end
        else if (start) begin
            if (i == 0) begin
                // Initialization cycle
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                i <= i + 1;
                done <= 1'b0;
            end
            else if (i < 16) begin
                // Processing cycles
                if (areg[i-1]) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
                i <= i + 1;
                done <= (i == 15); // Set done one cycle early
            end
            else begin
                // Final cycle (i == 16)
                yout <= yout_r;
                i <= 4'b0;
                done <= 1'b1;
            end
        end
        else begin
            // Start not asserted
            i <= 4'b0;
            done <= 1'b0;
        end
    end

endmodule