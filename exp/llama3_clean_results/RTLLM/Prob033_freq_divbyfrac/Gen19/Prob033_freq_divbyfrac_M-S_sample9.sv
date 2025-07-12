module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV1_CLK = 4;      // Clock cycles for first phase
parameter DIV2_CLK = 3;      // Clock cycles for second phase

// Internal signals
reg [2:0] cnt;  // Counter for 7 clock cycles

// Sequential logic for counters
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div <= 1'b0;
    end else begin
        // Counter for 7 clock cycles
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate divided clock signal
        if ((cnt == DIV1_CLK - 1) || (cnt == MUL2_DIV_CLK - 1)) begin
            clk_div <= 1'b1;
        end else begin
            clk_div <= 1'b0;
        end
    end
end

endmodule