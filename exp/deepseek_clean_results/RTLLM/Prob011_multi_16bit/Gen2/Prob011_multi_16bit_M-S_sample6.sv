module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] i;            // Reduced to 4-bit counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] acc;         // Accumulator register

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset condition
            i <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
            done <= 1'b0;
            yout <= 32'd0;
        end else begin
            if (start) begin
                if (i == 4'd0) begin
                    // Initialize operation
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'd0;
                    done <= 1'b0;
                    i <= i + 1;
                end else if (i < 4'd16) begin
                    // Shift-and-add operation
                    if (areg[i-1]) begin
                        acc <= acc + (breg << (i-1));
                    end
                    i <= i + 1;
                    
                    // Final result and done flag
                    if (i == 4'd15) begin
                        yout <= acc + (areg[15] ? (breg << 15) : 0);
                        done <= 1'b1;
                    end
                end else begin
                    // Clear done when new start expected
                    done <= 1'b0;
                    i <= 4'd0;
                end
            end else begin
                // Idle state
                i <= 4'd0;
                done <= 1'b0;
            end
        end
    end

endmodule