module freq_diveven #(
    parameter NUM_DIV = 10 // division factor (even number)
) (
    input  clk,        // input clock signal
    input  rst_n,      // active-low reset signal
    output clk_div     // divided clock output signal
);

reg [3:0] cnt;         // 4-bit counter
reg       clk_div;     // divided clock output signal

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt   <= 4'd0; // initialize counter to zero on reset
        clk_div <= 1'b0; // initialize divided clock output signal to zero on reset
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // increment counter
        end else begin
            cnt   <= 4'd0; // reset counter
            clk_div <= ~clk_div; // toggle divided clock output signal
        end
    end
end

endmodule