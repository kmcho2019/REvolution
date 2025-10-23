module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [4:0] i; // Shift count register
reg [15:0] areg; // Multiplicand register
reg [15:0] breg; // Multiplier register
reg [31:0] yout_r; // Product register
reg done_r; // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else if (start) begin // Start signal active
        if (i < 17) begin
            i <= i + 1;
        end
        if (i == 0) begin // Initialize multiplicand and multiplier registers
            areg <= ain;
            breg <= bin;
        end
        if (i > 0 && i < 17) begin // Shift and accumulate operation
            if (areg[i-1]) begin // If bit at position i-1 is high
                yout_r <= yout_r + (breg << (i-1)); // Accumulate shifted value of multiplier
            end
        end
        if (i == 16) begin // Multiplication completion flag
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
        end
    end else begin // Start signal inactive
        i <= 0;
    end
end

assign yout = yout_r; // Output assignment
assign done = done_r; // Completion flag assignment

endmodule