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
reg [31:0] acc;
reg [4:0] count;  // 0-15 (4 bits sufficient)

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Synchronous reset
        areg <= 16'b0;
        breg <= 16'b0;
        acc <= 32'b0;
        count <= 5'd16; // Initialize to idle state
        done <= 1'b0;
        yout <= 32'b0;
    end
    else begin
        if (start) begin
            if (count == 5'd16) begin
                // Initial cycle - load operands
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                count <= 5'd0;
                done <= 1'b0;
            end
            else if (count < 5'd15) begin
                // Processing cycles 0-14
                if (areg[0]) begin
                    acc <= acc + {16'b0, breg} << count;
                end
                areg <= areg >> 1;  // Shift to check next bit
                count <= count + 1;
                done <= 1'b0;
            end
            else if (count == 5'd15) begin
                // Final cycle (15)
                if (areg[0]) begin
                    acc <= acc + {16'b0, breg} << 15;
                end
                yout <= acc;  // Capture final result
                done <= 1'b1;
                count <= 5'd16;  // Return to idle
            end
        end
        else begin
            // Not started - maintain idle state
            count <= 5'd16;
            done <= 1'b0;
        end
    end
end

endmodule