module multi_16bit(
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

reg [4:0] i; // Shift count register
reg [15:0] areg; // Multiplicand register
reg [15:0] breg; // Multiplier register
reg [31:0] yout_r; // Product register
reg done_r; // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin // Reset condition
        i <= 5'd0; // Reset shift count to 0
        areg <= 16'd0; // Reset multiplicand register to 0
        breg <= 16'd0; // Reset multiplier register to 0
        yout_r <= 32'd0; // Reset product register to 0
        done_r <= 1'b0; // Reset multiplication completion flag to 0
    end else if (start) begin // Start signal is active
        if (i == 5'd0) begin // Initialize multiplicand and multiplier registers
            areg <= ain;
            breg <= bin;
        end
        if (i < 5'd17) begin // Increment shift count
            i <= i + 1'd1;
        end
        if (i > 5'd0 && i < 5'd17) begin // Shift and accumulate operation
            if (areg[i-1]) begin // Check bit at position i-1 in multiplicand register
                yout_r <= yout_r + (breg << (i-1)); // Accumulate shifted value of multiplier register
            end
        end
        if (i == 5'd16) begin // Set multiplication completion flag to 1
            done_r <= 1'b1;
        end else if (i == 5'd17) begin // Reset multiplication completion flag to 0
            done_r <= 1'b0;
            i <= 5'd0; // Reset shift count to 0
        end
    end else begin // Start signal is inactive
        i <= 5'd0; // Reset shift count to 0
    end
end

always @(*) begin
    yout = yout_r; // Assign product output
    done = done_r; // Assign multiplication completion flag
end

endmodule