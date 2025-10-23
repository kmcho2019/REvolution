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
reg [31:0] shifted_b [0:15];  // Pre-computed shifted versions
reg [31:0] yout_r;
reg [3:0] i;                  // Reduced from 5 to 4 bits
reg done_r;
wire active;

assign active = start && (i <= 15);
assign done = done_r;

// Pre-compute all possible shifted versions of breg
always @(*) begin
    if (start && i == 0) begin
        for (integer j = 0; j < 16; j = j + 1) begin
            shifted_b[j] = bin << j;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        areg <= 16'b0;
        yout_r <= 32'b0;
        i <= 4'b0;
        done_r <= 1'b0;
    end
    else begin
        if (start) begin
            if (i == 0) begin
                // Load multiplicand at start
                areg <= ain;
                yout_r <= 32'b0;
                i <= i + 1;
                done_r <= 1'b0;
            end
            else if (i <= 15) begin
                // Conditional add operation using pre-shifted values
                if (areg[i-1]) begin
                    yout_r <= yout_r + shifted_b[i-1];
                end
                
                // Update counter and done flag
                if (i == 15) begin
                    done_r <= 1'b1;
                    i <= i + 1;
                end
                else begin
                    i <= i + 1;
                end
            end
            else begin
                // Hold state until start is deasserted
                done_r <= 1'b0;
            end
        end
        else begin
            // Not started - reset counter and done flag
            i <= 4'b0;
            done_r <= 1'b0;
        end
    end
end

// Output assignment - direct register output
always @(*) begin
    yout = yout_r;
end

endmodule