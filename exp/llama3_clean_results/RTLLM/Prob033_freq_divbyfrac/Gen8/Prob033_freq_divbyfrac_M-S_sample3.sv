module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter MUL2_DIV_CLK = 7;  // Total clock cycles for 3.5x division

// Internal signals
reg [2:0] cnt;  // Counter to track clock cycles

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div <= 1'b0;
    end else begin
        if (cnt == MUL2_DIV_CLK - 1) begin
            cnt <= 3'b000;
        end else begin
            cnt <= cnt + 1'b1;
        end
        
        // Generate divided clock
        if ((cnt == 1) || (cnt == 4)) begin
            clk_div <= ~clk_div;
        end
    end
end

endmodule