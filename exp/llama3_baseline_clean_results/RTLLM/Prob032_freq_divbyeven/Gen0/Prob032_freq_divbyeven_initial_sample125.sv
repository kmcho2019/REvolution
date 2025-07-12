module freq_diveven #(
    parameter NUM_DIV = 4  // even number division factor
)(
    input  logic clk,     // input clock signal
    input  logic rst_n,   // active-low reset signal
    output logic clk_div  // divided clock output signal
);

logic [3:0] cnt;  // 4-bit counter
logic clk_div_q; // internal divided clock signal

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin  // reset condition
        cnt <= 4'b0;
        clk_div_q <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1;
        end else begin
            cnt <= 4'b0;
            clk_div_q <= ~clk_div_q;
        end
    end
end

assign clk_div = clk_div_q;  // continuous assignment for output

endmodule