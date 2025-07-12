module freq_diveven #(
    parameter NUM_DIV = 10  // even number to divide the input clock frequency
) (
    input  clk,            // input clock signal
    input  rst_n,          // active-low reset signal
    output reg clk_div     // divided clock output signal
);

reg [3:0] cnt;             // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin      // active-low reset
        cnt <= 4'd0;        // reset counter
        clk_div <= 1'b0;    // reset divided clock output
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // increment counter
        end else begin
            cnt <= 4'd0;    // reset counter
            clk_div <= ~clk_div; // toggle divided clock output
        end
    end
end

endmodule