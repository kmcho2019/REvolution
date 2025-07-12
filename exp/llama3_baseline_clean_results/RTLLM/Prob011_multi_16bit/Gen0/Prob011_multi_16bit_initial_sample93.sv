module multi_16bit(
    input           clk,        // Chip clock signal
    input           rst_n,      // Active-low reset signal
    input           start,      // Chip enable signal to initiate the multiplication operation
    input  [15:0]   ain,        // Input signal representing the multiplicand (a) with a data width of 16 bits
    input  [15:0]   bin,        // Input signal representing the multiplier (b) with a data width of 16 bits
    output [31:0]   yout,       // Product output signal with a data width of 32 bits
    output          done        // Chip output flag signal. Defined as 1 indicates the completion of the multiplication operation
);

reg [31:0] yout_r;      // Product register
reg [15:0] areg;        // Multiplicand register
reg [15:0] breg;        // Multiplier register
reg [4:0]   i;          // Shift count register
reg         done_r;     // Multiplication completion flag register

// Update shift count register (i)
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        i <= 0;
    end else if (start) begin
        if (i < 17) begin
            i <= i + 1;
        end else begin
            i <= i;
        end
    end else begin
        i <= 0;
    end
end

// Update multiplication completion flag (done_r)
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        done_r <= 0;
    end else if (i == 16) begin
        done_r <= 1;
    end else if (i == 17) begin
        done_r <= 0;
    end else begin
        done_r <= done_r;
    end
end

// Shift and accumulate operation
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else if (start) begin
        if (i == 0) begin
            areg <= ain;
            breg <= bin;
            yout_r <= 0;
        end else if (i > 0 && i < 17) begin
            if (areg[i-1]) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end else begin
            areg <= areg;
            breg <= breg;
            yout_r <= yout_r;
        end
    end else begin
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end
end

// Output assignment
assign yout = yout_r;
assign done = done_r;

endmodule