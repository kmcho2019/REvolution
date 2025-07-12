module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;      // 4-bit counter (0-15)
    reg [31:0] acc;   // Accumulator register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            acc <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
        end
        else begin
            if (start) begin
                if (i == 0) begin
                    // Initialize operation
                    acc <= 32'b0;
                    i <= i + 1;
                    done <= 1'b0;
                    
                    // First cycle: check LSB and add if needed
                    if (ain[0]) begin
                        acc <= bin;
                    end
                end
                else if (i < 16) begin
                    // Shift-and-add operation
                    if (ain[i]) begin
                        acc <= acc + (bin << i);
                    end
                    i <= i + 1;
                    done <= (i == 15);
                end
                else begin
                    // Multiplication complete
                    i <= 0;
                    done <= 1'b0;
                end
            end
            else begin
                // Not started
                i <= 0;
                done <= 1'b0;
            end
        end
    end

    // Output assignment
    always @(posedge clk) begin
        if (i == 16) begin
            yout <= acc;
        end
    end

endmodule