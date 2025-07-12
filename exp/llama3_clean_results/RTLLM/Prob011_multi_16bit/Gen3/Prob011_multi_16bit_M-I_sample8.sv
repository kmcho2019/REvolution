module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [31:0] yout_r;
reg [15:0] areg;
reg [15:0] breg;
reg [4:0] i;

// Simplified control logic for better readability and performance
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // Reset conditions
        i <= 0;
        done <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else if (start && i < 16) begin
        // Increment shift count and perform multiplication
        i <= i + 1;
        if (i == 1) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end else if (i > 1 && i <= 16) begin
            // Shift and accumulate operation optimized for minimal transitions
            if (areg[i-2]) begin
                yout_r <= yout_r + (breg << (i-2));
            end
        end
    end else if (~start) begin
        // Reset on start deassertion
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end
    
    // Update done flag
    if (i == 16) begin
        done <= 1;
    end else if (i == 17 || ~start) begin
        done <= 0;
    end
end

assign yout = yout_r;

endmodule