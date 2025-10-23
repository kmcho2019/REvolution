module multi_16bit (
    input clk,         // Chip clock signal
    input rst_n,       // Active-low reset signal
    input start,       // Chip enable signal to initiate the multiplication operation
    input [15:0] ain,  // Input signal representing the multiplicand (a) with a data width of 16 bits
    input [15:0] bin,  // Input signal representing the multiplier (b) with a data width of 16 bits
    output [31:0] yout, // Product output signal with a data width of 32 bits
    output done        // Chip output flag signal
);

reg [4:0] i;           // Shift count register
reg [15:0] areg;       // Multiplicand register
reg [15:0] breg;       // Multiplier register
reg [31:0] yout_r;     // Product register
reg done_r;           // Multiplication completion flag

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else if (start) begin
        if (i < 16) begin
            i <= i + 1;
            if (i == 1) begin
                areg <= ain;
                breg <= bin;
            end
            if (i > 1 && areg[i-2] == 1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end else if (i == 16) begin
            done_r <= 1;
        end else if (i == 17) begin
            done_r <= 0;
            i <= 0;
        end
    end else begin
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule