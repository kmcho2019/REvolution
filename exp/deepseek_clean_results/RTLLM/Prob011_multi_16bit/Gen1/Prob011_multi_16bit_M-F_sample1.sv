module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [15:0] areg, breg;
reg [31:0] yout_r;
reg [4:0] i;  // Counts 0-15 (16 cycles)
reg done_r;

assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        areg <= 16'b0;
        breg <= 16'b0;
        yout_r <= 32'b0;
        i <= 5'b0;
        done_r <= 1'b0;
        yout <= 32'b0;
    end
    else begin
        if (start) begin
            if (i == 0) begin
                // Load operands at start
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                done_r <= 1'b0;
            end
            
            // Shift-and-add operation
            if (i < 16) begin
                if (areg[i]) begin
                    yout_r <= yout_r + (breg << i);
                end
                
                // Set done flag on last cycle
                if (i == 15) begin
                    done_r <= 1'b1;
                end
                else begin
                    done_r <= 1'b0;
                end
                
                i <= i + 1;
            end
            else begin
                // Hold state after completion
                done_r <= 1'b0;
            end
        end
        else begin
            // Clear counter when not started
            i <= 5'b0;
            done_r <= 1'b0;
        end
        
        // Output assignment
        yout <= yout_r;
    end
end

endmodule