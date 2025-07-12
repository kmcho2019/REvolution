module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;
    reg [31:0] shifted [0:15]; // Pre-calculated shifts
    reg [3:0] i; // 4-bit counter (0-15)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            yout <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
        end
        else begin
            if (start) begin
                if (i == 0) begin
                    // Initialization cycle
                    areg <= ain;
                    yout <= 32'b0;
                    done <= 1'b0;
                    
                    // Pre-calculate all possible shifts
                    for (integer j = 0; j < 16; j = j + 1) begin
                        shifted[j] <= bin << j;
                    end
                    
                    i <= i + 1;
                end
                else if (i <= 15) begin
                    // Processing cycles
                    if (areg[i-1]) begin
                        yout <= yout + shifted[i-1];
                    end
                    
                    // Set done flag when last cycle completes
                    done <= (i == 15);
                    i <= i + 1;
                end
                else begin
                    // Operation complete, reset counter
                    i <= 4'b0;
                    done <= 1'b0;
                end
            end
            else begin
                // Start not asserted, reset everything
                i <= 4'b0;
                done <= 1'b0;
            end
        end
    end

endmodule