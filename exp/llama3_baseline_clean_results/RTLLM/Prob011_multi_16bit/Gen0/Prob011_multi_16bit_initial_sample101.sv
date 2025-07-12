module multi_16bit (
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [4:0] i;  // Shift count register
reg [15:0] areg;  // Multiplicand register
reg [15:0] breg;  // Multiplier register
reg [31:0] yout_r;  // Product register
reg done_r;  // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else if (start) begin  // Start multiplication
        if (i < 16) begin
            i <= i + 1;
        end
        if (i == 0) begin  // Initialize registers
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end else if (i > 0 && i < 17) begin  // Shift and accumulate
            if (areg[i-1] == 1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end
        if (i == 16) begin  // Set completion flag
            done_r <= 1;
        end else if (i == 17) begin  // Reset completion flag
            done_r <= 0;
        end
    end else begin  // Reset shift count
        i <= 0;
    end
end

always @(posedge clk) begin
    yout <= yout_r;  // Assign product output
    done <= done_r;  // Assign completion flag
end

endmodule