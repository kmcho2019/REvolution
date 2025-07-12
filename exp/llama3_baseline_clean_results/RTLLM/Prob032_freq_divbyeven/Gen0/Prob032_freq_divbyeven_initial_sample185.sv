// freq_diveven module: a frequency divider that divides the input clock frequency by even numbers
module freq_diveven #(
    parameter NUM_DIV = 4  // division factor (must be an even number)
)(
    input  wire clk,      // input clock signal
    input  wire rst_n,    // active-low reset signal
    output wire clk_div   // divided clock output signal
);

reg [3:0] cnt;            // 4-bit counter to track clock cycles
reg       clk_div_reg;    // register to store the divided clock signal

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset counter and divided clock signal on active-low reset
        cnt <= 4'b0;
        clk_div_reg <= 1'b0;
    end else if (cnt < (NUM_DIV / 2) - 1) begin
        // increment counter without changing divided clock output
        cnt <= cnt + 1;
    end else begin
        // reset counter and toggle divided clock output
        cnt <= 4'b0;
        clk_div_reg <= ~clk_div_reg;
    end
end

assign clk_div = clk_div_reg;  // assign divided clock signal to output

endmodule