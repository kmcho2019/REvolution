module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [15:0] areg, breg;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;

assign done = done_r;
assign yout = yout_r;

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
            case (i)
                5'd0: begin
                    // Initial state - load operands
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 32'b0;
                    i <= i + 1;
                    done_r <= 1'b0;
                end
                5'd16: begin
                    // Final state - set done flag
                    done_r <= 1'b1;
                    i <= i + 1;
                end
                5'd17: begin
                    // Idle state after completion
                    done_r <= 1'b0;
                end
                default: begin
                    // Processing states (1-15)
                    if (breg[i-1]) begin
                        yout_r <= yout_r + (areg << (i-1));
                    end
                    i <= i + 1;
                end
            endcase
        end
        else begin
            // Not started - reset counter and done flag
            i <= 5'b0;
            done_r <= 1'b0;
        end
    end
end

endmodule