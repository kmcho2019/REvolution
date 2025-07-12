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
    reg [3:0] i;      // Shift counter (0-15)

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            breg <= 16'b0;
            yout <= 32'b0;
            i <= 4'b0;
            done <= 1'b0;
        end
        else if (start) begin
            if (i == 0) begin
                // Initialize operation
                areg <= ain;
                breg <= bin;
                yout <= 32'b0;
                i <= i + 1;
                done <= 1'b0;
            end
            else if (i < 16) begin
                // Shift-and-add operation
                if (areg[0]) begin
                    yout <= yout + (breg << (i-1));
                end
                areg <= areg >> 1;  // Shift multiplicand right
                i <= i + 1;
                done <= (i == 15) ? 1'b1 : 1'b0;
            end
            else begin
                // Operation complete
                i <= 4'b0;
                done <= 1'b0;
            end
        end
        else begin
            // Idle state
            i <= 4'b0;
            done <= 1'b0;
        end
    end

endmodule