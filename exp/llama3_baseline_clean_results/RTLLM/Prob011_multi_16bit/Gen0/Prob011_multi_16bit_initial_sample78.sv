module multi_16bit(
    input clk, rst_n, start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

reg [4:0] i; // Shift count register
reg [15:0] areg; // Multiplicand register
reg [15:0] breg; // Multiplier register
reg [31:0] yout_r; // Product register
reg done_r; // Multiplication completion flag register

// Output assignment
assign yout = yout_r;
assign done = done_r;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin // Reset condition
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else begin
        if (start) begin // Start signal active
            if (i < 17) begin
                i <= i + 1; // Increment shift count
                if (i == 16) begin
                    done_r <= 1; // Set completion flag
                end else if (i == 17) begin
                    done_r <= 0; // Reset completion flag
                end
            end
            if (i == 0) begin // Store inputs
                areg <= ain;
                breg <= bin;
            end else if (i > 0 && i < 17) begin
                if (areg[i-1]) begin // Check bit at position i-1
                    yout_r <= yout_r + (breg << (i-1)); // Accumulate shifted multiplier
                end
            end
        end else begin // Start signal inactive
            i <= 0; // Reset shift count
        end
    end
end

endmodule