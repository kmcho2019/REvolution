module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;  // Multiplicand register
    reg [15:0] breg;  // Multiplier register
    reg [31:0] yout_r; // Product register
    reg [4:0] i;      // Shift counter (0-16)
    reg done_r;       // Internal done flag

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            i <= 5'b0;
            done_r <= 1'b0;
        end
        else begin
            if (start) begin
                if (i == 0) begin
                    // Load operands at start
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                    i <= i + 1;
                    done_r <= 1'b0;
                end
                else if (i < 17) begin
                    // Shift-and-add operation
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                    done_r <= (i == 16) ? 1'b1 : 1'b0;
                end
                else begin
                    // Multiplication complete
                    done_r <= 1'b0;
                end
            end
            else begin
                // Not started or completed
                i <= 5'b0;
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