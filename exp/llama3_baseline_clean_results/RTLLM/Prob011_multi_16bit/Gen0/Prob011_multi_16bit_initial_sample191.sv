module multi_16bit(
    input clk,        // Chip clock signal
    input rst_n,      // Active-low reset signal
    input start,      // Chip enable signal to initiate the multiplication operation
    input [15:0] ain,  // Input signal representing the multiplicand (a)
    input [15:0] bin,  // Input signal representing the multiplier (b)
    output reg [31:0] yout,  // Product output signal
    output reg done   // Chip output flag signal indicating completion of the multiplication operation
);

reg [15:0] areg;  // Multiplicand register
reg [15:0] breg;  // Multiplier register
reg [31:0] yout_r;  // Product register
reg [4:0] i;  // Shift count register
reg done_r;  // Multiplication completion flag register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin  // Reset condition
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        if (start) begin
            if (i < 17) begin
                i <= i + 1;
            end else begin
                i <= 0;
            end
        end else begin
            i <= 0;
        end

        if (i == 16) begin
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
        end

        if (i == 0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end else if (i > 0 && i < 17) begin
            if (areg[15 - (i - 1)]) begin
                yout_r <= yout_r + (breg << (i - 1));
            end
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule