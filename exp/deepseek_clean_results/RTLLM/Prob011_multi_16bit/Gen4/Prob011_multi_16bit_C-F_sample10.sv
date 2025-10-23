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
    reg [3:0] i; // 4-bit counter (0-15)
    reg processing;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
            processing <= 1'b0;
        end
        else begin
            if (start && !processing) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                i <= 4'b0;
                done <= 1'b0;
                processing <= 1'b1;
            end
            else if (processing) begin
                if (i < 15) begin
                    // Normal processing cycle
                    if (areg[i]) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    i <= i + 1;
                end
                else begin
                    // Final cycle (i=15)
                    if (areg[i]) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    done <= 1'b1;
                    processing <= 1'b0;
                end
            end
            else begin
                // Idle state
                done <= 1'b0;
            end
        end
    end

    // Synchronous output registration
    always @(posedge clk) begin
        if (done) begin
            yout <= yout_r;
        end
    end

endmodule