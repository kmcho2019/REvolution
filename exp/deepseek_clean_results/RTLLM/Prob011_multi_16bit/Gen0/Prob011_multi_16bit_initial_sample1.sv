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
    reg [4:0] i;
    reg done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end else begin
            if (start) begin
                if (i == 0) begin
                    // Initialization phase
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                    i <= i + 1;
                    done_r <= 1'b0;
                end else if (i <= 16) begin
                    // Shift and accumulate phase
                    if (breg[i-1]) begin
                        yout_r <= yout_r + (areg << (i-1));
                    end
                    i <= i + 1;
                    done_r <= (i == 16) ? 1'b1 : 1'b0;
                end else begin
                    // Multiplication complete
                    i <= 5'b0;
                    done_r <= 1'b0;
                end
            end else begin
                // Not started or completed
                i <= 5'b0;
                done_r <= 1'b0;
            end
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            yout <= yout_r;
            done <= done_r;
        end
    end

endmodule