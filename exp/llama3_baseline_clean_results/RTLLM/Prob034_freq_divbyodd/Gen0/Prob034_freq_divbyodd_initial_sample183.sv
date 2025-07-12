module freq_divbyodd #(
    parameter NUM_DIV = 5 // Default odd divisor value
)(
    input  clk,       // Input clock signal
    input  rst_n,      // Active low reset signal
    output clk_div     // Divided clock output
);

reg [31:0] cnt1;  // Counter for rising edges
reg [31:0] cnt2;  // Counter for falling edges
reg       clk_div1;  // Divided clock for positive edges
reg       clk_div2;  // Divided clock for negative edges
reg       prev_clk;  // Previous clock value

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt1  <= 0;
        cnt2  <= 0;
        clk_div1 <= 1'b0;
        clk_div2 <= 1'b0;
        prev_clk <= 1'b0;
    end else begin
        if (prev_clk == 1'b1 && clk == 1'b0) begin // Falling edge
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end
        end

        if (prev_clk == 1'b0 && clk == 1'b1) begin // Rising edge
            cnt1 <= cnt1 + 1;
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end
        end

        prev_clk <= clk;
    end
end

assign clk_div = clk_div1 | clk_div2;

endmodule