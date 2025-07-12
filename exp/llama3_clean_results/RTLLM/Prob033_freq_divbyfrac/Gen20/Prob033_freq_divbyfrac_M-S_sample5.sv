module freq_divbyfrac (
    input  clk,        // Input clock signal
    input  rst_n,       // Active low reset signal
    output reg clk_div  // Fractionally divided clock output
);

// Parameters for fractional frequency division
parameter DIV_CLK = 7;  // Total clock cycles for 3.5x division
parameter DIV_CLK_LONG = 4;  // Longer part of the divided clock cycle
parameter DIV_CLK_SHORT = 3;  // Shorter part of the divided clock cycle

// Internal signal
reg [2:0] cnt;  // Counter

// Sequential logic for counter
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 3'b000;
        clk_div <= 1'b0;
    end else if (cnt == DIV_CLK - 1) begin
        cnt <= 3'b000;
    end else begin
        cnt <= cnt + 1'b1;
    end
end

// Combinatorial logic to generate divided clock signal
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_div <= 1'b0;
    end else begin
        case (cnt)
            3'b000: clk_div <= 1'b1;
            3'b100: clk_div <= 1'b0;
            3'b001: clk_div <= 1'b1;
            3'b011: clk_div <= 1'b0;
            default: clk_div <= 1'b0;
        endcase
    end
end

endmodule