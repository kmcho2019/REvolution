module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [3:0] count;  // Reduced to 4 bits (0-16)
    reg [15:0] areg;
    reg [31:0] shifted_bin;
    wire count_max = (count == 4'd16);  // Efficient max count detection

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            count <= 4'd0;
            areg <= 16'b0;
            shifted_bin <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            if (start) begin
                if (count == 0) begin
                    // Initialization phase
                    areg <= ain;
                    shifted_bin <= {16'b0, bin};
                    yout <= 32'b0;
                    done <= 1'b0;
                    count <= count + 1;
                end else if (!count_max) begin
                    // Multiplication phase (1-16)
                    if (areg[count-1]) begin
                        yout <= yout + shifted_bin;
                    end
                    
                    // Conditional shift (only when needed)
                    if (count < 15) begin  // No need to shift after last accumulation
                        shifted_bin <= shifted_bin << 1;
                    end
                    
                    count <= count + 1;
                end else begin
                    // Completion phase (count == 16)
                    done <= 1'b1;
                    count <= count + 1;  // Advance to idle state
                end
            end else begin
                // Idle state
                count <= 4'd0;
                done <= 1'b0;
            end
        end
    end

endmodule