module freq_diveven #(
    parameter NUM_DIV = 4  // even number division factor
) (
    input  clk,           // input clock signal
    input  rst_n,          // active-low reset signal
    output reg    clk_div  // divided clock output signal
);

reg [3:0] cnt;             // 4-bit counter

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin      // active-low reset
        cnt <= 4'd0;       // initialize counter
        clk_div <= 1'b0;   // initialize divided clock signal
    end else begin
        if (cnt < (NUM_DIV / 2 - 1)) begin
            cnt <= cnt + 1; // increment counter if less than half of NUM_DIV - 1
        end else begin
            cnt <= 4'd0;   // reset counter
            clk_div <= ~clk_div; // toggle divided clock signal
        end
    end
end

endmodule