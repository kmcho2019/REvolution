// Module: freq_divbyeven
// Description: Frequency divider that divides the input clock frequency by an even number specified by NUM_DIV.
// Parameters:
//   NUM_DIV: The even number by which the input clock frequency is divided.
module freq_divbyeven (
    input  clk,    // Input clock signal
    input  rst_n,  // Active-low reset signal
    output reg clk_div  // Divided clock output signal
);

parameter NUM_DIV = 8; // Must be an even number
parameter HALF_DIV = NUM_DIV / 2 - 1; // Precompute half of NUM_DIV - 1

// Dynamically size the counter based on NUM_DIV
localparam CNT_WIDTH = $clog2(HALF_DIV + 1);
reg [CNT_WIDTH-1:0] cnt; // Counter to track clock cycles

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt <= 0;
        clk_div <= 0;
    end else if (cnt == HALF_DIV) begin
        cnt <= 0;
        clk_div <= ~clk_div;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule