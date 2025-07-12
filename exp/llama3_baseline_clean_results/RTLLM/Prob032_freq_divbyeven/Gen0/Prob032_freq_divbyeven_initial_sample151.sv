module freq_diveven #(
    parameter NUM_DIV = 4 // even number division factor
) (
    input  wire        clk,    // input clock signal
    input  wire        rst_n,  // active-low reset signal
    output reg         clk_div // divided clock output signal
);

reg [3:0] cnt; // 4-bit counter register

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // reset counter and divided clock output on active-low reset
        cnt <= 4'd0;
        clk_div <= 1'b0;
    end else begin
        if (cnt < (NUM_DIV / 2) - 1) begin
            // increment counter without changing divided clock output
            cnt <= cnt + 1'd1;
        end else begin
            // reset counter and toggle divided clock output
            cnt <= 4'd0;
            clk_div <= ~clk_div;
        end
    end
end

endmodule