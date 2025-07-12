module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [3:0] i;            // Reduced to 4-bit counter (0-16)
reg [15:0] areg, breg;  // Multiplicand and multiplier registers
reg [31:0] yout_r;      // Product register
reg done_r;             // Done flag register
wire active;            // Active computation signal

assign active = start && (i < 4'd16);
assign done = done_r;
assign yout = done_r ? yout_r : 32'b0;  // Gated output

// Combined control and data path
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        i <= 4'd0;
        done_r <= 1'b0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
    end
    else begin
        if (start) begin
            if (i == 4'd0) begin
                // Initialize operation
                areg <= ain;
                breg <= bin;
                yout_r <= 32'd0;
                i <= i + 1'b1;
                done_r <= 1'b0;
            end
            else if (i < 4'd16) begin
                // Shift-and-add operation
                if (breg[0]) begin
                    yout_r <= yout_r + areg;
                end
                // Shift multiplicand left, multiplier right
                areg <= areg << 1;
                breg <= breg >> 1;
                i <= i + 1'b1;
                
                // Set done flag one cycle early
                if (i == 4'd15) begin
                    done_r <= 1'b1;
                end
            end
            else begin
                // Operation complete
                done_r <= 1'b0;
            end
        end
        else begin
            // Idle state
            i <= 4'd0;
            done_r <= 1'b0;
        end
    end
end

endmodule