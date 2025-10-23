module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;  // Multiplicand register
    reg [15:0] breg;  // Multiplier register
    reg [31:0] acc;   // Accumulator
    reg [4:0] i;      // Shift counter (0-16)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            i <= 5'b0;
            done <= 1'b0;
        end
        else if (start) begin
            if (i == 0) begin
                // Load operands at start
                areg <= ain;
                breg <= bin;
                acc <= 32'b0;
                i <= i + 1;
                done <= 1'b0;
            end
            else if (i < 16) begin
                // Shift-and-add operation
                if (areg[i-1]) begin
                    acc <= acc + (breg << (i-1));
                end
                i <= i + 1;
            end
            else begin
                // Final cycle
                if (areg[15]) begin
                    acc <= acc + (breg << 15);
                end
                yout <= acc;
                done <= 1'b1;
                i <= 0;
            end
        end
        else begin
            // Idle state
            i <= 0;
            done <= 1'b0;
        end
    end

endmodule