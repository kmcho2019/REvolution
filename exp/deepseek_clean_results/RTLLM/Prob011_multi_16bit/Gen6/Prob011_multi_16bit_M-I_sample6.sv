module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [15:0] areg;
reg [31:0] breg_shifted [15:0];
reg [31:0] yout_r;
reg [3:0] i;  // Reduced to 4 bits
reg done_r;
reg active;

// Precompute all shifted versions of B
wire [31:0] breg_ext = {16'b0, bin};

// Clock gating control
wire clk_en = active | !rst_n;

assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        areg <= 16'b0;
        yout_r <= 32'b0;
        i <= 4'b0;
        done_r <= 1'b0;
        active <= 1'b0;
    end
    else begin
        if (start && !active) begin
            // Start new multiplication
            areg <= ain;
            for (integer j=0; j<16; j=j+1) begin
                breg_shifted[j] <= breg_ext << j;
            end
            yout_r <= 32'b0;
            i <= 4'b0;
            done_r <= 1'b0;
            active <= 1'b1;
        end
        else if (active) begin
            if (i < 15) begin
                // Normal operation
                if (areg[i]) begin
                    yout_r <= yout_r + breg_shifted[i];
                end
                i <= i + 1;
            end
            else begin
                // Final cycle
                if (areg[i]) begin
                    yout_r <= yout_r + breg_shifted[i];
                end
                done_r <= 1'b1;
                active <= 1'b0;
            end
        end
    end
end

// Output assignment only when done
always @(*) begin
    yout = done_r ? yout_r : 32'b0;
end

endmodule