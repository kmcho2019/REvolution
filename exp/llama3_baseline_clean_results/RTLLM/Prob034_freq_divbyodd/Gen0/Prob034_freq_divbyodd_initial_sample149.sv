module freq_divbyodd #(
    parameter NUM_DIV = 5  // Default divisor value
)(
    input clk,
    input rst_n,
    output reg clk_div
);

reg [2:0] cnt1;  // Counter for rising edge
reg [2:0] cnt2;  // Counter for falling edge
reg clk_div1;   // Divided clock for positive edge
reg clk_div2;   // Divided clock for negative edge
reg prev_clk;   // Previous clock value

always @(*) begin
    if (!rst_n) begin
        cnt1 <= 0;
        cnt2 <= 0;
        clk_div1 <= 0;
        clk_div2 <= 0;
    end else begin
        if (clk && !prev_clk) begin  // Rising edge
            cnt1 <= cnt1 + 1;
            if (cnt1 == (NUM_DIV / 2)) begin
                clk_div1 <= ~clk_div1;
                cnt1 <= 0;
            end
        end else if (!clk && prev_clk) begin  // Falling edge
            cnt2 <= cnt2 + 1;
            if (cnt2 == (NUM_DIV / 2)) begin
                clk_div2 <= ~clk_div2;
                cnt2 <= 0;
            end
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        prev_clk <= 0;
        clk_div <= 0;
    end else begin
        prev_clk <= clk;
        clk_div <= clk_div1 | clk_div2;
    end
end

endmodule