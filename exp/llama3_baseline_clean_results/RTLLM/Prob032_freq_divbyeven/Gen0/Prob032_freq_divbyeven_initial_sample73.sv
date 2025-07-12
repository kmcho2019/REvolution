module freq_diveven #(
    parameter NUM_DIV = 4 // even number, example value
) (
    input  logic clk,    // input clock
    input  logic rst_n,  // active-low reset
    output logic clk_div  // divided clock output
);

logic [3:0] cnt;  // 4-bit counter
logic         clk_div_int;  // internal divided clock signal

assign clk_div = clk_div_int;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // reset counter and internal divided clock signal
        cnt           <= 4'b0;
        clk_div_int   <= 1'b0;
    end else if (cnt < (NUM_DIV / 2 - 1)) begin
        // increment counter without changing divided clock output
        cnt <= cnt + 1'b1;
    end else begin
        // reset counter and toggle divided clock output
        cnt           <= 4'b0;
        clk_div_int   <= ~clk_div_int;
    end
end

endmodule