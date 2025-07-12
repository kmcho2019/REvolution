module multi_16bit (
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
        i <= 5'd0;
        areg <= 16'd0;
        breg <= 16'd0;
        yout_r <= 32'd0;
        done_r <= 1'b0;
    end else begin
        if (start) begin // Start signal is active
            if (i < 5'd16) begin // Shift count is less than 17
                i <= i + 1'b1; // Increment shift count
                if (i == 5'd1) begin // First clock cycle
                    areg <= ain; // Store multiplicand
                    breg <= bin; // Store multiplier
                end
                if (i > 5'd0 && i < 5'd17) begin // Shift and accumulate operation
                    if (areg[i-1]) begin // If bit at position i-1 is high
                        yout_r <= yout_r + (breg << (i-1)); // Accumulate shifted value of multiplier
                    end
                end
            end
        end else begin // Start signal is inactive
            i <= 5'd0; // Reset shift count
            areg <= 16'd0; // Reset multiplicand register
            breg <= 16'd0; // Reset multiplier register
            yout_r <= 32'd0; // Reset product register
        end
        if (i == 5'd16) begin // Multiplication completion flag generation
            done_r <= 1'b1; // Set completion flag
        end else if (i == 5'd17) begin
            done_r <= 1'b0; // Reset completion flag
        end
    end
end

assign yout = yout_r; // Output assignment
assign done = done_r;

endmodule