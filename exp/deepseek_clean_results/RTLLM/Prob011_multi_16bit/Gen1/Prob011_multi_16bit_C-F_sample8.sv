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
    reg [3:0] i; // Reduced to 4 bits (0-15)
    reg running;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 4'b0;
            running <= 1'b0;
        end else begin
            if (start && !running) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                i <= 4'b0;
                running <= 1'b1;
            end else if (running) begin
                if (i < 15) begin
                    // Shift and accumulate phase
                    if (areg[i]) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    i <= i + 1;
                end else begin
                    // Final cycle (i=15)
                    if (areg[i]) begin
                        yout_r <= yout_r + (breg << i);
                    end
                    running <= 1'b0;
                end
            end
        end
    end

    // Output assignments with registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            yout <= yout_r;
            // Done is high for one cycle after completion
            done <= (i == 15) && running;
        end
    end

endmodule